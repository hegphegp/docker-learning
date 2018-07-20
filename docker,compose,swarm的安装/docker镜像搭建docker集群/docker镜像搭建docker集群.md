# docker镜像搭建docker集群.md

* 有时候想搭建多节点的swarm集群学习，没多台机器怎么办，没多台虚拟机怎么办，没足够内存创建虚拟机怎么办
* 没办法，只能通过swarm的docker镜像来搭建swarm集群，所有的swarm集群操作和真实环境没多大区别，妈妈再也不用担心我没有资源搭建集群学习了

#### 环境准备
```
系统环境 Ubuntu-16.04，Centos7
软件环境 docker-17.03.0-ce以上高版本
确定以上两点环境都准备好了之后，直接copy下面的命令行直接运行，可以搭建swarm集群
```

#### 先把创建好的swarm集群日志，看看是否和真实环境一致
#### 创建swarm集群的效率是如此之高，不用1分钟，6台独立的docker主机就创建好了，然后就可以搭建集群了
```
hgp@hgp-PC:~/docker$ docker ps -a
CONTAINER ID         IMAGE             COMMAND                CREATED          STATUS       PORTS      NAMES
152d14edd51d   docker:18.03-dind   "dockerd-entrypoint.…"   8 seconds ago   Up 4 seconds   2375/tcp   manager1
9df8acb58698   docker:18.03-dind   "dockerd-entrypoint.…"   2 minutes ago   Up 2 minutes   2375/tcp   worker3
39ecf8a99551   docker:18.03-dind   "dockerd-entrypoint.…"   2 minutes ago   Up 2 minutes   2375/tcp   worker2
6c6c19d665b8   docker:18.03-dind   "dockerd-entrypoint.…"   2 minutes ago   Up 2 minutes   2375/tcp   worker1
e57517267351   docker:18.03-dind   "dockerd-entrypoint.…"   2 minutes ago   Up 2 minutes   2375/tcp   manager3
3c327a5cc723   docker:18.03-dind   "dockerd-entrypoint.…"   2 minutes ago   Up 2 minutes   2375/tcp   manager2


hgp@hgp-PC:~/docker$ docker exec -it manager1 docker node ls
ID                               HOSTNAME   STATUS   AVAILABILITY   MANAGER STATUS      ENGINE VERSION
fn7c4kr0x43wz2n00vqgw8eaq *   152d14edd51d   Ready     Active            Leader            18.03.1-ce
dxxuye28ty2beuhxwk22a2y6o     e57517267351   Ready     Active            Reachable         18.03.1-ce
t556phbglsg1eopsbhgx40da7     3c327a5cc723   Ready     Active            Reachable         18.03.1-ce
rzmb8wa7gwjl5orhpzhsk0j50     6c6c19d665b8   Ready     Active                              18.03.1-ce
abpkfzgq6fnm6xwjsvqgu05aj     9df8acb58698   Ready     Active                              18.03.1-ce
or2n5oi06hbbgrikdsopp483w     39ecf8a99551   Ready     Active                              18.03.1-ce
```

##### 创建6台docker虚拟机
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

##### 以下是集群搭建的命令
```
docker exec -it manager1 docker swarm init
# 然后通过 docker swarm join-token manager ，获取manager的token，给集群加入管理节点
# docker exec -it manager1 docker swarm join-token manager
# docker exec -it manager2 docker swarm join --token SWMTKN-1-3lx8svps26qetemxr2ayer0impnbbib48e9ehrqsqjzvj40far-4oe2hfhhoec8k8omnxypoi12k 10.10.10.101:2377
# docker exec -it manager3 docker swarm join --token SWMTKN-1-3lx8svps26qetemxr2ayer0impnbbib48e9ehrqsqjzvj40far-4oe2hfhhoec8k8omnxypoi12k 10.10.10.101:2377

# 然后通过 docker swarm join-token worker ，获取worker的token，给集群加入工作节点
# docker exec -it manager1 docker swarm join-token worker
# docker exec -it worker1 docker swarm join --token SWMTKN-1-3lx8svps26qetemxr2ayer0impnbbib48e9ehrqsqjzvj40far-bgxwyk1qkzppz08cy4e15e4za 10.10.10.101:2377
# docker exec -it worker2 docker swarm join --token SWMTKN-1-3lx8svps26qetemxr2ayer0impnbbib48e9ehrqsqjzvj40far-bgxwyk1qkzppz08cy4e15e4za 10.10.10.101:2377
# docker exec -it worker3 docker swarm join --token SWMTKN-1-3lx8svps26qetemxr2ayer0impnbbib48e9ehrqsqjzvj40far-bgxwyk1qkzppz08cy4e15e4za 10.10.10.101:2377
```