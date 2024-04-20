#!/bin/bash
set -ex
cd "$(dirname "$0")"

clear

microk8s kubectl delete all --all --force=true

docker build -t frontend:1 ./frontend
docker save frontend:1 -o frontend.tar
sudo microk8s images import < frontend.tar
rm frontend.tar

docker build -t backend:1 ./backend
docker save backend:1 -o backend.tar
sudo microk8s images import < backend.tar
rm backend.tar

microk8s kubectl apply -f config.yaml
microk8s kubectl apply -f metallb.yaml

microk8s kubectl apply -f psql.yaml
microk8s kubectl wait --for=condition=ready --timeout=5m pod -l app=postgres

microk8s kubectl apply -f redis.yaml
microk8s kubectl wait --for=condition=ready pod -l app=redis

microk8s kubectl apply -f backend.yaml
microk8s kubectl wait --for=condition=ready pod -l app=backend

microk8s kubectl apply -f frontend.yaml
microk8s kubectl wait --for=condition=ready pod -l app=frontend

sleep 3

curl http://192.168.10.19:4000/redis
curl http://192.168.10.19:4000/psql
curl http://192.168.10.19:30000
curl http://192.168.10.19
