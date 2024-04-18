# sudo snap install multipass

# multipass launch --name node1 --memory 4G --disk 30G
# multipass mount $(pwd) node1:/home/ubuntu/my-data
# multipass shell node1

sudo snap install microk8s --classic
sudo microk8s reset

microk8s enable dashboard
microk8s enable dns
microk8s enable registry
microk8s enable istio
echo "주소 범위로 192.168.49.100-192.168.49.250 을 입력한다"
microk8s enable metallb
microk8s enable ingress
microk8s enable metrics-server
microk8s enable hostpath-storage
