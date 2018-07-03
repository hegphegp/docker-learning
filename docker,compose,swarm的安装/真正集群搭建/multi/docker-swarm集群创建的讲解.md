# docker-swarm集群创建的讲解

#### 可能线上没有节点名称，只能用节点的标识ID

```
因为swarm使用的是raft集群管理方式所以集群内节点分为三种角色：头目（leader）,被选举者（Reachable），小弟（worker）。头目和被选举者其实都是manager，根据下图可以看出swarn集群中至少得有2个可用的被选举节点才能选举主节点出来，否则集群将无法执行操作。
```

##### 开启防火墙后却没有开放端口，映射容器端口可能会抛错
```
docker run -itd --restart always --name redis -p 6379:6379 redis:4.0.9-alpine
docker: Error response from daemon: driver failed programming external connectivity on endpoint redis (a0434cdd951209bfee416e1da2b8d0e038ab607efd4b315d43409ed523fe728e):  (iptables failed: iptables --wait -t nat -A DOCKER -p tcp -d 0/0 --dport 6379 -j DNAT --to-destination 172.17.0.2:6379 ! -i docker0: iptables: No chain/target/match by that name.(exit status 1))
```

#### 关闭防火墙或者开放2377，4789，7946端口，如果关闭防火墙，端口不需要开放
* TCP      2377 用于集群管理通信(管理节点)
* TCP/UDP  4789 用于 overlay 网络流量(所有节点)
* TCP/UDP  7946 用于节点间通信(所有节点)
* TCP      2375 docker的restful API接口(所有节点)
```
# 方法一：关闭防火墙，禁止防火墙开机启动
systemctl stop firewalld
systemctl disable firewalld

# 方法二：开启防火墙，开放这几个端口(如果要映射容器端口，运行容器的时候就要开放)，在管理节点和worker开放相应的端口
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --list-ports
firewall-cmd --zone=public --remove-port=2377/tcp --permanent
firewall-cmd --zone=public --remove-port=4789/tcp --permanent
firewall-cmd --zone=public --remove-port=4789/udp --permanent
firewall-cmd --zone=public --remove-port=7946/tcp --permanent
firewall-cmd --zone=public --remove-port=7946/udp --permanent
firewall-cmd --zone=public --remove-port=2375/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports
```

#### 防火墙的内容
* 无论防火墙是否开启，都不需要在防火墙开放22端口，ssh都可以访问到22端口
```
# firewall-cmd --zone=public(作用域) --add-port=80/tcp(端口和访问类型) --permanent(永久生效)
查看所有打开的端口： firewall-cmd --zone=public --list-ports
更新防火墙规则： firewall-cmd --reload
查看区域信息:  firewall-cmd --get-active-zones
查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0
拒绝所有包：firewall-cmd --panic-on
取消拒绝状态： firewall-cmd --panic-off
查看是否拒绝： firewall-cmd --query-panic

添加端口：firewall-cmd --zone=public --add-port=80/tcp --permanent (--permanent永久生效，没有此参数重启后失效)
重新载入：firewall-cmd --reload
查看：firewall-cmd --zone= public --query-port=80/tcp
删除：firewall-cmd --zone= public --remove-port=80/tcp --permanent
```

##### docker-machine查看节点的各种信息
```
docker-machine env 节点名称
```
##### 在其中一台manager节点初始化swarm manager并指定网卡地址(虚拟机是单网卡的不需要指定网卡地址)
```
docker swarm init --advertise-addr 192.168.10.117
```
##### 查看连接令牌
```
# 查看worker节点加入的令牌
docker swarm join-token worker
# 查看manager节点加入的令牌
docker swarm join-token manager
# 使旧令牌无效并生成新令牌
docker swarm join-token --rotate
```
##### 加入节点
```
docker swarm join --token SWMTKN-1-5d2xxxxxxxxxxxxxxxxxx 192.168.10.117:2377
```
##### 查看集群中的节点
```
# 查看集群中的节点
docker node ls
# 查看集群中节点信息
docker node inspect 节点名称 --pretty
# 查看集群中节点信息
docker node inspect 节点名称 --pretty
```
##### 删除节点(集群不能直接删除manger节点，集群先将manager降级为node节点才可以删除)
```
# 如果节点是主动离开集群的，离开后集群内还有该节点信息，但是该节点已经不再主动加入集群，所以需要从集群删除本该，该节点才能重新加入到集群，如果集群不删除该节点的信息，即使该节点重新加入，除了新加入的这条节点信息，还会有之前那条节点信息，但是那条信息是无法再使用的，因为manager节点不能删除，所以需要先降级为worker才能删除。
# manger节点自动离开集群。该manger节点是主动离开集群的，所以集群内还有本节点信息，该manager节点在集群还显示，只是状态为down，但是这条记录是没用的了，所以集群要将这条记录降级为worker，然后移除该记录。在这个节点再执行docker swarm join --token manager-token-xxxxxxxxx命令，还可以加入集群。但是再加入集群时，旧的那条记录还是显示为down，同时会新加一条信息。所以节点执行离开集群的命令后，集群也要执行删除那个节点的命令
docker swarm leave --force
# 集群将该节点对应的记录降级为worker，然后删除
docker node demote 节点名称
docker node rm 节点的标识ID
docker node demote 节点的标识ID
docker node rm 节点名称

# worker节点自动离开集群。该worker节点执行离开集群的命令后，在集群的管理节点查看，该worker节点在集群还显示，只是状态为down。在这个节点再执行docker swarm join --token worker-token-xxxxxxxxx命令，还可以加入集群。但是再加入集群时，旧的那条记录还是显示为down，同时会新加一条信息。所以节点执行离开集群的命令后，集群也要执行删除那个节点的命令
docker swarm leave
docker node rm 节点的标识ID
docker node rm 节点名称
# 集群删除manger节点(应先在集群的管理节点执行命令(docker node update --availability drain 要删除的节点名称)把这个节点容器迁移到其他节点，然后再把节点从集群中去掉)
```
##### 设置集群可以将任务分配给某个节点
```
docker node update --availability active 节点名称
```
##### 设置集群不给某个节点分配新任务，但是现有任务仍然保持运行
```
docker node update --availability pause 节点名称
```
##### 设置集群不给某个节点分配新任务，把该节点现有的所有任务自动迁移到其他节点，并清空该节点的所有服务
```
docker node update --availability drain 节点名称
# 该节点可以用 docker node update --availability active 节点名称 命令恢复该节点
```
##### 节点标签
```
# 添加节点标签
docker node update --label-add label1 --label-add bar=label2 节点名称
# 删除节点标签
docker node update --label-rm label1 节点名称
```
##### worker与manager相互切换
```
# worker节点升级为manager节点
docker node promote 节点名称
# manager节点降级为worker节点
docker node demote 节点名称
```
##### 查看服务
```
# 查看服务列表
docker service ls
# 查看服务的具体信息
docker service ps redis
```



# 到这里了

##### 创建一个不定义name，不定义replicas的服务
```
docker service create nginx
```
##### 创建一个指定name的服务
```
docker service create --name my_web nginx
```
##### 创建一个指定name、run cmd的服务
```
docker service create --name helloworld alping ping docker.com
```
##### 创建一个指定name、version、run cmd的服务
```
docker service create --name helloworld alping:3.6 ping docker.com
```
##### 创建一个指定name、port、replicas的服务
```
docker service create --name my_web --replicas 3 -p 80:80 nginx
```
##### 为指定的服务更新一个端口
```
docker service update --publish-add 80:80 my_web
```
##### 为指定的服务删除一个端口
```
docker service update --publish-rm 80:80 my_web
```
##### 将redis:3.0.6更新至redis:3.0.7
```
docker service update --image redis:3.0.7 redis
```
##### 配置运行环境，指定工作目录及环境变量
```
docker service create --name helloworld --env MYVAR=myvalue --workdir /tmp --user my_user alping ping docker.com
```
##### 创建一个helloworld的服务
```
docker service create --name helloworld alpine ping docker.com
```
##### 更新helloworld服务的运行命令
```
docker service update --args "ping www.baidu.com" helloworld
```
##### 删除一个服务
```
docker service rm my_web
```
##### 在每个群组节点上运行web服务
```
docker service create --name tomcat --mode global --publish mode=host,target=8080,published=8080 tomcat:latest
```
##### 创建一个overlay网络
```
docker network create --driver overlay my_network
docker network create --driver overlay --subnet 10.10.10.0/24 --gateway 10.10.10.1 my-network
```
##### 创建服务并将网络添加至该服务
```
docker service create --name test --replicas 3 --network my-network redis
```
##### 删除群组网络
```
docker service update --network-rm my-network test
```
##### 更新群组网络
```
docker service update --network-add my_network test
```
##### 创建群组并配置cpu和内存
```
docker service create --name my_nginx --reserve-cpu 2 --reserve-memory 512m --replicas 3 nginx
```
##### 更改所分配的cpu和内存
```
docker service update --reserve-cpu 1 --reserve-memory 256m my_nginx
```
##### 指定每次更新的容器数量
```
--update-parallelism
```
##### 指定容器更新的间隔
```
--update-delay
```
##### 定义容器启动后监控失败的持续时间
```
--update-monitor
```
##### 定义容器失败的百分比
```
--update-max-failure-ratio
```
##### 定义容器启动失败之后所执行的动作
```
--update-failure-action
```
##### 创建一个服务并运行3个副本，同步延迟10秒，10%任务失败则暂停
```
docker service create --name mysql_5_6_36 --replicas 3 --update-delay 10s --update-parallelism 1 --update-monitor 30s --update-failure-action pause --update-max-failure-ratio 0.1 -e MYSQL_ROOT_PASSWORD=123456 mysql:5.6.36
```
##### 回滚至之前版本
```
docker service update --rollback mysql
```
##### 自动回滚
```
# 如果服务部署失败，则每次回滚2个任务，监控20秒，回滚可接受失败率20%
docker service create --name redis --replicas 6 --rollback-parallelism 2 --rollback-monitor 20s --rollback-max-failure-ratio .2 redis:latest
```
##### 创建服务并将目录挂在至container中
###### Bind带来的风险 
* 绑定的主机路径必须存在于每个集群节点上，否则会有问题 
* 调度程序可能会在任何时候重新安排运行服务容器，如果目标节点主机变得不健康或无法访问 
* 主机绑定数据不可移植，当你绑定安装时，不能保证你的应用程序开发方式与生产中的运行方式相同
```
docker service create --name mysql --publish 3306:3306 --mount type=bind,src=/data/mysql,dst=/var/lib/mysql --replicas 3 -e MYSQL_ROOT_PASSWORD=123456 mysql:5.6.36
```
##### 添加swarm配置
```
echo "this is a mysql config" | docker config create mysql -
```
##### 查看配置
```
docker config ls
```
##### 查看配置详细信息
```
docker config inspect mysql
```
##### 删除配置
```
docker config rm mysql
```
##### 添加配置
```
docker service update --config-add mysql mysql
```
##### 删除配置
```
docker service update --config-rm mysql mysql
```
##### 添加配置
```
docker config create homepage index.html
```
##### 启动容器的同时添加配置
```
docker service create --name nginx --publish 80:80 --replicas 3 --config src=homepage,target=/usr/share/nginx/html/index.html nginx 
```
