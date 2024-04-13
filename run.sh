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
minikube start --force --nodes 1 --addons=ingress --addons=metallb

check_minikube_ip

minikube image load node-server:2

kubectl apply -f config.yaml
kubectl apply -f secret.yaml

kubectl apply -f redis.yaml

kubectl apply -f metallb-config.yaml
kubectl apply -f server-app.yaml

kubectl wait --for=condition=ready pod -l app=MyApp
kubectl logs -l app=MyApp

curl -d Hello http://192.168.49.100:4000

# redis 설정
# psql 설정
