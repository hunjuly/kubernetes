#!/bin/bash
set -ex
cd "$(dirname "$0")"

clear

minikube delete --all
minikube start --force \
    --cpus=no-limit \
    --memory=no-limit \
    --disk-size='20000g' \
    --nodes 1 \
    --addons=ingress \
    --addons=metallb \
    --addons=metrics-server

# nfs csi 설치
curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/v4.6.0/deploy/install-driver.sh | bash -s v4.6.0 --

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=example.com"
kubectl create secret tls secret-tls --key key.pem --cert cert.pem
rm key.pem cert.pem

docker build -t frontend:1 ./frontend
minikube image load frontend:1

docker build -t backend:1 ./backend
minikube image load backend:1

kubectl apply -f config.yaml
kubectl apply -f metallb.yaml

kubectl apply -f psql.yaml
kubectl wait --for=condition=ready --timeout=5m pod -l app=postgres

kubectl apply -f redis.yaml
kubectl wait --for=condition=ready pod -l app=redis

kubectl apply -f backend.yaml
kubectl wait --for=condition=ready pod -l app=backend

kubectl apply -f frontend.yaml
kubectl wait --for=condition=ready pod -l app=frontend

sleep 3

curl http://192.168.49.100:4000/redis
curl http://192.168.49.100:4000/psql
curl -k https://example.com
