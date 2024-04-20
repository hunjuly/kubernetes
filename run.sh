#!/bin/bash
set -ex
cd "$(dirname "$0")"

clear

sudo mkdir -p /microk8s/volume
sudo chmod -R 777 /microk8s/volume

microk8s kubectl delete all --all --force=true

docker build -t node-server:2 ./server
docker save node-server:2 -o node-server.tar
sudo microk8s images import < node-server.tar
rm node-server.tar

microk8s kubectl apply -f config.yaml
microk8s kubectl apply -f metallb.yaml
microk8s kubectl apply -f psql.yaml
microk8s kubectl apply -f redis.yaml
microk8s kubectl apply -f backend.yaml

microk8s kubectl wait --for=condition=ready --timeout=5m pod -l app=postgres
microk8s kubectl wait --for=condition=ready pod -l app=redis
microk8s kubectl wait --for=condition=ready pod -l app=backend

sleep 3

curl http://192.168.49.100:4000/redis
curl http://192.168.49.100:4000/psql
