# docker-swarm集群创建的讲解

* 关闭防火墙

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
* 无论防火墙是否开启，都不需要在防火墙开放22端口，ssh登录22端口都是可以通讯的
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


##### 初始化swarm manager并制定网卡地址(虚拟机是单网卡的不需要指定网卡地址)
```
docker swarm init --advertise-addr 192.168.10.117
```
##### 强制删除集群，如果是manager，需要加 --force
```
docker swarm leave --force
docker node rm docker-118
```
##### 查看swarm worker的连接令牌
```
docker swarm join-token worker
```
##### 查看swarm manager的连接令牌
```
docker swarm join-token manager
```
##### 使旧令牌无效并生成新令牌
```
docker swarm join-token --rotate
```
##### 加入docker swarm集群
```
docker swarm join --token SWMTKN-1-5d2ipwo8jqdsiesv6ixze20w2toclys76gyu4zdoiaf038voxj-8sbxe79rx5qt14ol14gxxa3wf 192.168.10.117:2377
```
##### 查看集群中的节点
```
docker node ls
```
##### 查看集群中节点信息
```
docker node inspect docker-117 --pretty
```
##### 调度程序可以将任务分配给节点
```
docker node update --availability active docker-118
```
##### 调度程序不向节点分配新任务，但是现有任务仍然保持运行
```
docker node update --availability pause docker-118
```
##### 调度程序不会将新任务分配给节点。调度程序关闭任何现有任务并在可用节点上安排它们
```
docker node update --availability drain docker-118
```
##### 添加节点标签
```
docker node update --label-add label1 --label-add bar=label2 docker-117
```
##### 删除节点标签
```
docker node update --label-rm label1 docker-117
```
##### 将节点升级为manager
```
docker node promote docker-118
```
##### 将节点降级为worker
```
docker node demote docker-118
```
##### 查看服务列表
```
docker service ls
```
##### 查看服务的具体信息
```
docker service ps redis
```
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
