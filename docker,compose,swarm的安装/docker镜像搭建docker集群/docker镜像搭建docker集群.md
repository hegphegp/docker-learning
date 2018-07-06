# docker镜像搭建docker集群.md
```
docker network rm docker-swarm-network
docker network create --subnet=10.10.10.0/24 docker-swarm-network
docker run -itd --name manager1 --net docker-swarm-network --ip 10.10.10.101 --restart always docker:18.03.1-ce
docker run -itd --name manager2 --net docker-swarm-network --ip 10.10.10.102 --restart always docker:18.03.1-ce
docker run -itd --name manager3 --net docker-swarm-network --ip 10.10.10.103 --restart always docker:18.03.1-ce
docker run -itd --name worker1 --net docker-swarm-network --ip 10.10.10.104 --restart always docker:18.03.1-ce
docker run -itd --name worker2 --net docker-swarm-network --ip 10.10.10.105 --restart always docker:18.03.1-ce
docker run -itd --name worker3 --net docker-swarm-network --ip 10.10.10.106 --restart always docker:18.03.1-ce
```