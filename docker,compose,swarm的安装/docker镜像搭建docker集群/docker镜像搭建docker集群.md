# docker镜像搭建docker集群.md

```
docker镜像的版本号以bind结尾的应该都可以作为真正的docker来使用
```

```
docker stop manager1
docker stop manager2
docker stop manager3
docker stop worker1
docker stop worker2
docker stop worker3
docker rm manager1
docker rm manager2
docker rm manager3
docker rm worker1
docker rm worker2
docker rm worker3

docker network rm docker-swarm-network
docker network create --subnet=10.10.10.0/24 docker-swarm-network

echo '{ "registry-mirrors": ["https://1a5q7qx0.mirror.aliyuncs.com"] }' > daemon.json

docker run --privileged -itd --name manager1 --net docker-swarm-network --ip 10.10.10.101 --restart always docker:18.03-dind
sleep 2
docker cp daemon.json manager1:/etc/docker
docker run --privileged -itd --name manager2 --net docker-swarm-network --ip 10.10.10.102 --restart always docker:18.03-dind
sleep 2
docker cp daemon.json manager2:/etc/docker
docker run --privileged -itd --name manager3 --net docker-swarm-network --ip 10.10.10.103 --restart always docker:18.03-dind
sleep 2
docker cp daemon.json manager3:/etc/docker
docker run --privileged -itd --name worker1 --net docker-swarm-network --ip 10.10.10.104 --restart always docker:18.03-dind
sleep 2
docker cp daemon.json worker1:/etc/docker
docker run --privileged -itd --name worker2 --net docker-swarm-network --ip 10.10.10.105 --restart always docker:18.03-dind
sleep 2
docker cp daemon.json worker2:/etc/docker
docker run --privileged -itd --name worker3 --net docker-swarm-network --ip 10.10.10.106 --restart always docker:18.03-dind
sleep 2
docker cp daemon.json worker3:/etc/docker
```