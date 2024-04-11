#!/bin/bash
set -ex
cd "$(dirname "$0")"

clear
minikube delete --all
# minikube start --force --static-ip 172.16.0.2
# minikube start --force -p demo --nodes 2
minikube start --force
kubectl cluster-info dump
kubectl get nodes

# deploy
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
kubectl get deployments

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
kubectl logs $POD_NAME
kubectl exec -it $POD_NAME -- ls -al

# create service
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl get services
kubectl describe services/kubernetes-bootcamp
# deleting a service
# kubectl delete service -l app=kubernetes-bootcamp

export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
curl $(minikube ip):$NODE_PORT

# label 사용하기
kubectl describe deployment
kubectl get pods -l app=kubernetes-bootcamp
kubectl get services -l app=kubernetes-bootcamp

# label 설정하기
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
kubectl label pods $POD_NAME version=v1
kubectl describe pods $POD_NAME
kubectl get pods -l version=v1

# set scale
kubectl get rs
kubectl scale deployments/kubernetes-bootcamp --replicas=4
kubectl get pods -o wide

# update app

# 사전적 의미로 `release`와 `rollout`은 비슷한 뜻을 가지고 있지만, 약간의 차이가 있습니다.
# 1. `Release`:
#    - 일반적으로 소프트웨어나 제품의 새로운 버전을 공개하는 것을 의미합니다.
#    - 개발 과정이 완료되고, 테스트를 거쳐 사용자가 사용할 수 있는 상태로 만드는 것을 말합니다.
#    - 주로 소프트웨어 개발 및 배포의 한 단계로 사용됩니다.

# 2. `Rollout`:
#    - 주로 새로운 기능, 디자인 또는 시스템을 점진적으로 도입하거나 배포하는 과정을 말합니다.
#    - 소프트웨어 업데이트를 단계적으로 배포하거나, 새로운 정책을 점진적으로 도입하는 것 등이 해당됩니다.
#    - 일반적으로 `release`보다는 점진적이고 단계적인 과정을 강조합니다.
# Kubernetes에서는 `rollout`이라는 용어를 사용하여 컨테이너화된 애플리케이션의 배포 및 업데이트 과정을 관리합니다. 이는 일반적인 소프트웨어 개발에서의 `release`와는 조금 다른 개념으로, 애플리케이션의 새 버전을 점진적으로 배포하고, 필요한 경우 이전 버전으로 쉽게 롤백할 수 있는 메커니즘을 제공합니다.
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
kubectl rollout status deployments/kubernetes-bootcamp
curl $(minikube ip):$NODE_PORT

# rollback
kubectl rollout undo deployments/kubernetes-bootcamp
curl $(minikube ip):$NODE_PORT
