# Redis-cluster-5.0.5集群搭建.md
> 5.0版本以后，redis-trib.rb 不再使用了，改成 redis-cli 命令创建集群，不再需要用ruby的gem安装redis的插件，然后通过redis-trib.rb 创建集群了，以后全面使用redis-5.0的版本


### redis-trib不设置密码的redis-cluster集群启动方式
```
# 用docker加上配置参数跑redis服务时,不能加--daemonize yes, 该参数为yes时, 表示以后台形式运行redis, 但是容器检测不到后台运行的程序的状况, 以为redis挂掉了, 容器就会退出
docker stop redis1 redis2 redis3 redis4 redis5 redis6
docker rm redis1 redis2 redis3 redis4 redis5 redis6
docker network rm redis-network
docker network create --subnet=10.10.57.0/24 redis-network

docker run -itd --name redis1 --net redis-network --ip 10.10.57.101 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0
docker logs redis1

docker run -itd --name redis2 --net redis-network --ip 10.10.57.102 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0
docker logs redis2

docker run -itd --name redis3 --net redis-network --ip 10.10.57.103 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0
docker logs redis3

docker run -itd --name redis4 --net redis-network --ip 10.10.57.104 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0
docker logs redis4

docker run -itd --name redis5 --net redis-network --ip 10.10.57.105 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0
docker logs redis5

docker run -itd --name redis6 --net redis-network --ip 10.10.57.106 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0
docker logs redis6

 docker exec -it redis1 sh
redis-cli --cluster create --cluster-replicas 1 10.10.57.101:6379 10.10.57.102:6379 10.10.57.103:6379 10.10.57.104:6379 10.10.57.105:6379 10.10.57.106:6379 
# 1) check命令:检查集群状态的命令，没有其他参数，只需要选择一个集群中的一个节点即可
redis-cli --cluster check 10.10.57.101:6379
# 2) info命令:用来查看集群的信息，没有其他参数，只需要选择一个集群中的一个节点即可
redis-cli --cluster info 10.10.57.101:6379
```

##### redis-trib创建带密码的redis-cluster集群，那么requirepass和masterauth都需要设置
```
docker stop redis1 redis2 redis3 redis4 redis5 redis6
docker rm redis1 redis2 redis3 redis4 redis5 redis6

docker network rm redis-network
docker network create --subnet=10.10.57.0/24 redis-network

docker run -itd --name redis1 --net redis-network --ip 10.10.57.101 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0 \
--requirepass admin \
--masterauth admin \
--cluster-node-timeout 5000
docker logs redis1

docker run -itd --name redis2 --net redis-network --ip 10.10.57.102 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0 \
--requirepass admin \
--masterauth admin \
--cluster-node-timeout 5000
docker logs redis2

docker run -itd --name redis3 --net redis-network --ip 10.10.57.103 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0 \
--requirepass admin \
--masterauth admin \
--cluster-node-timeout 5000
docker logs redis3

docker run -itd --name redis4 --net redis-network --ip 10.10.57.104 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0 \
--requirepass admin \
--masterauth admin \
--cluster-node-timeout 5000
docker logs redis4

docker stop redis5
docker rm redis5
docker run -itd --name redis5 --net redis-network --ip 10.10.57.105 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0 \
--requirepass admin \
--masterauth admin \
--cluster-node-timeout 5000
docker logs redis5

docker run -itd --name redis6 --net redis-network --ip 10.10.57.106 --restart always redis:5.0.5-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled yes \
--bind 0.0.0.0 \
--requirepass admin \
--masterauth admin \
--cluster-node-timeout 5000
docker logs redis6

 docker exec -it redis1 sh
 # 停止复制粘贴，后面命令粘贴进去，导致命令错行，人眼看起来很费劲，虽然命令能被正确识别和执行
 
 # 最后面加 -a 参数表示配置密码
 # redis-cli --cluster create --cluster-replicas 1 10.10.57.101:6379 10.10.57.102:6379 10.10.57.103:6379 10.10.57.104:6379 10.10.57.105:6379 10.10.57.106:6379  -a 密码
redis-cli --cluster create --cluster-replicas 1 10.10.57.101:6379 10.10.57.102:6379 10.10.57.103:6379 10.10.57.104:6379 10.10.57.105:6379 10.10.57.106:6379  -a admin

```
