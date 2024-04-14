#!/bin/bash

check_minikube_ip() {
    local MINIKUBE_IP=$(minikube ip)

    if [[ "$MINIKUBE_IP" != 192.168.49.* ]]; then
        echo "Minikube IP ($MINIKUBE_IP) is not within the expected range (192.168.49.x). Exiting..."
        exit 1
    fi

    echo "Minikube IP is within the expected range: $MINIKUBE_IP"
}

set -ex
cd "$(dirname "$0")"

clear
docker build -t node-server:2 ./server

minikube delete --all
minikube start --force \
    --cpus=no-limit \
    --memory=no-limit \
    --disk-size='20000g' \
    --nodes 1 \
    --addons=ingress \
    --addons=metallb \
    --mount=true \
    --mount-string="$HOST_PATH:/host-data"

check_minikube_ip

minikube image load node-server:2

kubectl apply -f metallb.yaml
kubectl apply -f psql.yaml
kubectl apply -f redis.yaml
kubectl apply -f app.yaml

kubectl wait --for=condition=ready --timeout=60s pod -l app=postgres
kubectl wait --for=condition=ready --timeout=60s pod -l app=redis
kubectl wait --for=condition=ready --timeout=60s pod -l app=MyApp

curl http://192.168.49.100:4000/redis
curl http://192.168.49.100:4000/psql
