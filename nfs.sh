#!/bin/bash

apt update
apt install -y nfs-kernel-server

mkdir -p /srv/nfs
chown nobody:nogroup /srv/nfs
chmod 0777 /srv/nfs

echo "/srv/nfs *(rw,sync,no_subtree_check,no_root_squash)" | tee /etc/exports
exportfs -a

systemctl restart nfs-kernel-server
