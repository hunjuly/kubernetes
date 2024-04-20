#!/bin/bash

echo "NFS 서버 설치 중..."
sudo apt update
sudo apt install -y nfs-kernel-server

echo "NFS 공유 디렉터리 생성 중..."
sudo mkdir -p /srv/nfs
sudo chown nobody:nogroup /srv/nfs
sudo chmod 0777 /srv/nfs

echo "NFS 설정을 추가 중..."
echo "/srv/nfs *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports

echo "NFS 설정 적용 중..."
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
