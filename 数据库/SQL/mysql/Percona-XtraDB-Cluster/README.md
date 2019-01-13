# Percona-XtraDB-Cluster的docker镜像的使用说明

#### docker镜像的地址页面  https://hub.docker.com/r/percona/percona-xtradb-cluster
#### 官方的github仓库地址  https://github.com/percona/percona-docker

### docker官方镜像的说明介绍
* One of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD or MYSQL_RANDOM_ROOT_PASSWORD must be defined
* The image will create the user xtrabackup@localhost for the XtraBackup SST method. If you want to use a password for the xtrabackup user, set XTRABACKUP_PASSWORD.
* If you want to use the discovery service (right now only etcd is supported), set the address to DISCOVERY_SERVICE. The image will automatically find a running cluser by CLUSTER_NAME and join to the existing cluster (or start a new one).
* If you want to start without the discovery service, use the CLUSTER_JOIN variable. Empty variables will start a new cluster, To join an existing cluster, set CLUSTER_JOIN to the list of IP addresses running cluster nodes.
### Percona-XtraDB-Cluster的docker官方镜像英文说明介绍的翻译
> MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD 和 MYSQL_RANDOM_ROOT_PASSWORD环境变量必须定义其中一个。
> 自动定义用户xtrabackup，可选设置xtrabackup user的密码(集群启动后可以查看数据库mysql表user，确实有该用户)
> 可以使用etcd注册服务，自动生成集群
> 不使用etcd，可以手动添加环境变量 CLUSTER_JOIN 添加集群

### docker镜像创建Percona-XtraDB-Cluster集群的方式有两种
> 一种是使用etcd注册服务，动态创建集群
> 一种是手动添加环境变量 CLUSTER_JOIN，手动创建集群

### 最重要的是官方提供了示例, 启动容器的脚本start_node.sh在github上面https://github.com/percona/percona-docker/blob/master/pxc-57/start_node.sh

### PerconaXtraDBCluster最少要求三个节点，后续的节点可以动态加入

### Percona每个节点可读可写，挂掉了某些节点都没影响