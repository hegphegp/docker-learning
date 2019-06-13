# Percona-XtraDB-Cluster的docker镜像的使用说明

#### 该docker镜像的官方地址  https://hub.docker.com/r/percona/percona-xtradb-cluster
#### 该项目的github官方地址  https://github.com/percona/percona-docker

#### 该docker官方镜像的英文说明介绍
* One of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD or MYSQL_RANDOM_ROOT_PASSWORD must be defined
* The image will create the user xtrabackup@localhost for the XtraBackup SST method. If you want to use a password for the xtrabackup user, set XTRABACKUP_PASSWORD.
* If you want to use the discovery service (right now only etcd is supported), set the address to DISCOVERY_SERVICE. The image will automatically find a running cluser by CLUSTER_NAME and join to the existing cluster (or start a new one).
* If you want to start without the discovery service, use the CLUSTER_JOIN variable. Empty variables will start a new cluster, To join an existing cluster, set CLUSTER_JOIN to the list of IP addresses running cluster nodes.
#### 该docker官方镜像的英文说明介绍的翻译
* MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD 和 MYSQL_RANDOM_ROOT_PASSWORD环境变量必须定义其中一个。
* 该docker镜像运行时自动创建用户xtrabackup，可通过XTRABACKUP_PASSWORD变量选设置xtrabackup的用户密码(集群启动后可以查看数据库mysql表user，确实有该用户)
* 创建集群的方式一: 可以使用etcd注册服务，自动生成集群
* 创建集群的方式二: 不使用etcd，可以手动添加环境变量 CLUSTER_JOIN 添加集群

#### docker镜像创建Percona-XtraDB-Cluster集群的方式有两种
* 一种是使用etcd注册服务，动态创建集群
* 一种是手动添加环境变量 CLUSTER_JOIN，手动创建集群

#### PerconaXtraDBCluster最少要求三个节点，后续的节点可以动态加入

#### Percona每个节点可读可写，挂掉了某些节点都没影响

#### docker单机部署的Percona-XtraDB-Cluster集群
```
docker ps -a -q --filter name=document

docker stop `docker ps -a -q --filter name=mysql-cluster-node`
docker rm `docker ps -a -q --filter name=mysql-cluster-node`

docker network rm percona-xtradb-cluster-network

docker network create percona-xtradb-cluster-network
# docker network create --subnet=10.10.57.0/24 percona-xtradb-cluster-network

# 暂时不挂载数据卷出来:/var/lib/mysql
docker run -itd --restart always -p 3307:3306 \
    --net=percona-xtradb-cluster-network \
    --name=mysql-cluster-node01 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e CLUSTER_NAME=cluster1 \
    percona/percona-xtradb-cluster:5.7.23


# 暂停1分钟，让mysql-cluster-node01处于完全就绪的状态


docker run -itd --restart always -p 3308:3306 \
    --net=percona-xtradb-cluster-network \
    --name=mysql-cluster-node02 \
    -e CLUSTER_JOIN=mysql-cluster-node01 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e CLUSTER_NAME=cluster1 \
    percona/percona-xtradb-cluster:5.7.23


# 暂停1分钟，让mysql-cluster-node02处于完全就绪的状态


docker run -itd --restart always -p 3309:3306 \
    --net=percona-xtradb-cluster-network \
    --name=mysql-cluster-node03 \
    -e CLUSTER_JOIN=mysql-cluster-node01 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e CLUSTER_NAME=cluster1 \
    percona/percona-xtradb-cluster:5.7.23


# 暂停1分钟，让mysql-cluster-node03处于完全就绪的状态


docker logs -f --tail=1000 mysql-cluster-node01
# 会显示集群创建成功的日志

# 用navicat在其中一个节点创建一个数据库, 然后去另外的节点查看, 发现创建的数据库会同步到所有节点, 形成多主集群
```

#### 官方提供了启动容器的start_node.sh脚本, 在github上面https://github.com/percona/percona-docker/blob/master/pxc-57/start_node.sh