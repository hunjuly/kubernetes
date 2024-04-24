#!/bin/bash
set -ex
cd "$(dirname "$0")"

sudo apt update
sudo apt install -y nfs-kernel-server

sudo mkdir -p /mnt/nfs
sudo chown nobody:nogroup /mnt/nfs
sudo chmod 0777 /mnt/nfs

echo "/mnt/nfs *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports
sudo exportfs -a

sudo systemctl restart nfs-kernel-server

# sudo mount -t nfs 192.168.10.20:/mnt/nfs $(pwd)/test

# docker rm -f nfs-server

# docker build -t nfs-server ./nfs-server

# docker run -d --name nfs-server --privileged \
#     --network=host \
#     -v $HOST_PATH/mnt:/nfsshare \
#     -e SHARED_DIRECTORY=/nfsshare \
#     nfs-server

# minikube delete --all
# minikube start --force \
#     --cpus=no-limit \
#     --memory=no-limit \
#     --disk-size='20000g' \
#     --nodes 1 \
#     --addons=ingress \
#     --addons=metallb \
#     --addons=metrics-server

# docker build -t backend:1 ./backend
# minikube image load backend:1

# kubectl apply -f config.yaml
# kubectl apply -f metallb.yaml
# kubectl apply -f backend.yaml
# kubectl wait --for=condition=ready pod -l app=backend
