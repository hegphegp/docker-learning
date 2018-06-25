# docker-machine搭建cluster集群.md

### 一次性关停所有集群  docker-machine stop `docker-machine ls | awk -F ' ' '{if(NR>1){print $1}}'`
### 一次性删除所有集群  docker-machine rm `docker-machine ls | awk -F ' ' '{if(NR>1){print $1}}'`

```
## 创建自定义网络
## --opt 指定网络安全模式
docker-machine ssh manager1 docker network create --driver overlay --subnet 10.0.0.1/24 --opt encrypted mynetwork

## 创建服务
--publish-add 8080:80 将容器的 80 映射到主机的 8080 端口
docker-machine ssh manager1 docker service create --replicas 6 --name my-nginx --network mynetwork --publish-add 8080:80 nginx:1.12-alpine

## 查看docker-swarm的服务
docker-machine ssh manager1 docker service ls
## 查看docker-swarm集群的具体服务
docker-machine ssh manager3 docker service ps 服务名
```