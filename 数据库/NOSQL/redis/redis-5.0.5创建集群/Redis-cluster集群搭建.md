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
```
# 查看所有节点信息，节点iD，节点卡槽，从节点没有卡槽
cluster nodes
# 1，add-node之后，要sleep足够长的时间（这里是20秒），让所有的节点都meet到新节点，否则会扩容失败
# 2，新节点的reshard之后要sleep足够长的时间（这里是20秒），否则继续reshard其他节点的slot会导致上一个reshared失败

# 集群的本质是执行两组命令，一个是将主节点加入到集群中，一个是依次对主节点添加slave节点，全程用redis-cli指令操作
1）增加主节点到集群中
redis-cli --cluster add-node 新节点IP:端口 集群任意节点IP:端口 -a 密码
2）为增加的主节点添加从节点
redis-cli --cluster add-node 新节点IP:端口 集群任意节点IP:端口 --cluster-slave --cluster-master-id 主节点ID -a 密码

# 迁移卡槽和数据，在要添加卡槽的主节点执行命令
# redis-cluster最大的败笔，加入集群的节点，必须先执行一条从其他节点分配卡槽的命令，默认不会自动给加入的节点自动分配卡槽。至少提供一条命令，在任意节点执行，自动平均分配卡槽，还要人去算卡槽，这些官方开发者的设计真糟糕。在默认均匀分配的情况下，居然不能提供执行一条命令，自动平均分配卡槽。
# 先给加入的节点，任意分配一点卡槽，再用 redis-cli --cluster rebalance 10.10.57.106:6379 -a 密码  命令，让集群自动平均分配卡槽
1）迁移卡槽，先随机给新节点分配任意数量卡槽，然后用 redis-cli --cluster rebalance 命令，让自动自动平均分配卡槽，除非每台机器的内存差距很大，才会脑残地手动指定卡槽数据

redis-cli -a 密码 --cluster reshard 集群任意节点IP:端口 --cluster-from 原节点ID --cluster-to 新节点ID --cluster-slots 卡槽数量 --cluster-yes --cluster-timeout 50000 --cluster-pipeline 10000 --cluster-replace

redis-cli --cluster rebalance 10.10.57.106:6379 -a 密码

# host:port：随便指定一个集群中的host:port，用以获取全部集群的信息
# --from：源节点的id，提示用户输入
# --to：目标节点的id，提示用户输入
# --slots：需要迁移的slot的总数量，提示用户输入
# --yes：当打印出slot迁移计划后是否需要用户输入yes确认后执行
# --timeout：控制每次migrate操作的超时时间，默认60000ms
# --pipeline：控制每次批量迁移的key的数量，默认10

# 要删除节点时，用迁移卡槽命令，把该节点的卡槽全部迁移到其他节点
# 先下线slave，再下线master可以防止不必要的数据复制
redis-cli -a 密码 --cluster reshard 集群任意节点IP:端口 --cluster-from 原节点ID --cluster-to 新节点ID --cluster-slots 直接写卡槽数量最大值16384 --cluster-yes --cluster-timeout 50000 --cluster-pipeline 10000 --cluster-replace
redis-cli -a 密码 --cluster del-node 节点IP:端口 要下线的节点ID
```