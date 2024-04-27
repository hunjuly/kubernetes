## 실행 방법

처음 실행 시 아래 명령을 순서대로 실행한다.

이 중에서 nfs.sh는 도커 환경 밖에서 실행해야 한다. nfs를 docker로 실행하는 방법을 찾지 못해서 부득이 이렇게 실행한다.

```sh
bash nfs.sh
bash init.sh
bash run.sh
```

nfs.sh는 테스트를 위해 필요한 것이다. 실제 운영 환경에서는 nfs server를 설치할 필요가 없을 것이다.

## backend 업데이트

아래 backend.yaml에서 `image: node-server:2` 이 부분을 변경해야 한다.

```yaml
...
    containers:
    - name: backend-container
        image: node-server:2
        ports:
        - containerPort: 3000
...
```

그 후 `microk8s kubectl apply -f backend.yaml` 실행한다

문제 발생 시 아래와 같이 롤백할 수 있다.

```sh
microk8s kubectl rollout undo deployment/backend
```

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
