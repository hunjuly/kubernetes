#!/bin/bash
set -ex
cd "$(dirname "$0")"

clear
minikube delete --all
minikube start --force --addons=ingress
kubectl cluster-info dump
kubectl get nodes

kubectl apply -f server-deploy.yaml
kubectl rollout status deployments/node-server

kubectl apply -f server-svc.yaml
sleep 2
curl -d Hello $(minikube ip):30000

kubectl apply -f server-ingress.yaml
sleep 2
curl -d Hello $(minikube ip)

# 에러 발생하면 로그 확인
# export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
# kubectl wait --for=condition=Ready pod/$POD_NAME
# kubectl wait --for=condition=ready pod -l app=node-server
# kubectl logs $POD_NAME
# kubectl get deployments
# kubectl get pods
