#!/bin/bash

sudo snap install microk8s --classic
sudo microk8s reset --destroy-storage

microk8s enable dashboard
microk8s enable dns
echo "주소 범위로 HostIP를 입력한다."
microk8s enable metallb
microk8s enable metrics-server
microk8s enable helm3
microk8s helm3 repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
microk8s helm3 repo update
microk8s helm3 install csi-driver-nfs csi-driver-nfs/csi-driver-nfs \
    --namespace kube-system \
    --set kubeletDir=/var/snap/microk8s/common/var/lib/kubelet
microk8s kubectl wait pod --selector app.kubernetes.io/name=csi-driver-nfs --for condition=ready --namespace kube-system
microk8s enable ingress

microk8s add-node -t abcdef1234567890abcdef1234567890
