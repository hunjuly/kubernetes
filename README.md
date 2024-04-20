## 실행 방법

처음 실행 시 아래 명령을 순서대로 실행한다.

```sh
bash nfs.sh
bash init.sh
bash run.sh
```

nfs.sh는 테스트를 위해 필요한 것이다. 실제 운영 환경에서는 nfs server를 설치할 필요가 없을 것이다.

## node 추가 방법

microk8s add-node 를 실행하면 `microk8s join ...`이렇게 token이 붙어서 나온다. 그대로 복사해서 추가하려는 노드에서 실행하면 된다.

```sh
hunjuly@home:~/kubernetes$ microk8s add-node

From the node you wish to join to this cluster, run the following:
microk8s join 192.168.10.19:25000/ef2ea68c50160f06bc5a4d768a28f9d2/21a8670f352b

Use the '--worker' flag to join a node as a worker not running the control plane, eg:
microk8s join 192.168.10.19:25000/ef2ea68c50160f06bc5a4d768a28f9d2/21a8670f352b --worker

If the node you are adding is not reachable through the default interface you can use one of the following:
microk8s join 192.168.10.19:25000/ef2ea68c50160f06bc5a4d768a28f9d2/21a8670f352b
microk8s join 172.17.0.1:25000/ef2ea68c50160f06bc5a4d768a28f9d2/21a8670f352b
microk8s join 172.18.0.1:25000/ef2ea68c50160f06bc5a4d768a28f9d2/21a8670f352b
```
