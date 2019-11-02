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
cd /opt/soft/swarm
docker stop manager1 manager2 manager3 worker1 worker2 worker3
docker rm manager1 manager2 manager3 worker1 worker2 worker3
rm -rf  manager1 manager2 manager3 worker1 worker2 worker3
mkdir -p manager1 manager2 manager3 worker1 worker2 worker3

docker network rm docker-swarm-network
docker network create --subnet=10.10.10.0/24 docker-swarm-network

echo '{ "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"] }' > daemon.json

docker run --privileged -itd --name manager1 --hostname manager1 --net docker-swarm-network --ip 10.10.10.101 --restart always -v $PWD/daemon.json:/etc/docker/daemon.json -v $PWD/manager1:/var/lib/docker docker:18.09-dind
docker run --privileged -itd --name manager2 --hostname manager2 --net docker-swarm-network --ip 10.10.10.102 --restart always -v $PWD/daemon.json:/etc/docker/daemon.json -v $PWD/manager2:/var/lib/docker docker:18.09-dind
docker run --privileged -itd --name manager3 --hostname manager3 --net docker-swarm-network --ip 10.10.10.103 --restart always -v $PWD/daemon.json:/etc/docker/daemon.json -v $PWD/manager3:/var/lib/docker docker:18.09-dind
docker run --privileged -itd --name worker1 --hostname worker1 --net docker-swarm-network --ip 10.10.10.104 --restart always -v $PWD/daemon.json:/etc/docker/daemon.json -v $PWD/worker1:/var/lib/docker docker:18.09-dind
docker run --privileged -itd --name worker2 --hostname worker2 --net docker-swarm-network --ip 10.10.10.105 --restart always -v $PWD/daemon.json:/etc/docker/daemon.json -v $PWD/worker2:/var/lib/docker docker:18.09-dind
docker run --privileged -itd --name worker3 --hostname worker3 --net docker-swarm-network --ip 10.10.10.106 --restart always -v $PWD/daemon.json:/etc/docker/daemon.json -v $PWD/worker3:/var/lib/docker docker:18.09-dind
```

##### 以下是集群搭建的命令
```
docker exec -it manager1 docker swarm init
# 然后通过 docker swarm join-token manager ，获取manager的token，给集群加入管理节点
# docker exec -it manager1 docker swarm join-token manager | sed -n '3p'
# docker exec -it manager2 docker swarm join --token SWMTKN-1-3avf9oczaew7wuagai7gmeho4vnj5nzuuedcs19ai4um7doh87-346v7h7a2iha9ppij9xom85v0 10.10.10.101:2377
# docker exec -it manager3 docker swarm join --token SWMTKN-1-3avf9oczaew7wuagai7gmeho4vnj5nzuuedcs19ai4um7doh87-346v7h7a2iha9ppij9xom85v0 10.10.10.101:2377

# 然后通过 docker swarm join-token worker ，获取worker的token，给集群加入工作节点
# docker exec -it manager1 docker swarm join-token worker | 
# docker exec -it worker1 docker swarm join --token SWMTKN-1-3avf9oczaew7wuagai7gmeho4vnj5nzuuedcs19ai4um7doh87-ab76i9tf2na5s9nhm77widlqv 10.10.10.101:2377
# docker exec -it worker2 docker swarm join --token SWMTKN-1-3avf9oczaew7wuagai7gmeho4vnj5nzuuedcs19ai4um7doh87-ab76i9tf2na5s9nhm77widlqv 10.10.10.101:2377
# docker exec -it worker3 docker swarm join --token SWMTKN-1-3avf9oczaew7wuagai7gmeho4vnj5nzuuedcs19ai4um7doh87-ab76i9tf2na5s9nhm77widlqv 10.10.10.101:2377

docker exec -it manager1 docker node ls

# # docker service create --name=viz --publish=8080:8080/tcp --constraint=node.role==manager --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock dockersamples/visualizer
# # docker exec -it manager1 sh -c "docker service create --replicas 12 --name viz --publish 8080:8080/tcp --constraint node.role==manager --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock dockersamples/visualizer"
# docker exec -it manager1 sh -c "docker service create --replicas 36 --name viz --publish 8080:8080/tcp --constraint node.role==manager --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock dockersamples/visualizer"
```