# elasticsearch单节点

### elasticsearch:5.6.10-alpine镜像的参数说明
```
# elasticsearch:5.6.10-alpine这个版本的镜像的数据保存目录和日志目录是
# 数据目录
/usr/share/elasticsearch/data
# 日志目录
/usr/share/elasticsearch/logs
# 或者通过/usr/share/elasticsearch/config/elasticsearch.yml配置文件修改path.data和path.logs参数
```

### elasticsearch:5.6.10-alpine镜像的配置文件参数说明(/usr/share/elasticsearch/config/elasticsearch.yml)
```
cluster.name: TEST 表示集群名称，同一集群的节点会协同来保存与检索数据
node.name: test1 表示节点名称
node.master: true 表示此节点的管理角色，master表示此节点是否可以成为主节点，一般默认为true
node.data: true 表示此节点的数据角色，data表示此节点是否用于保存数据，一般默认为true
path.data: /usr/share/elasticsearch/data 表示此节点的数据保存目录
path.logs: /usr/share/elasticsearch/logs 表示此节点的日志保存目录
network.host: 0.0.0.0 表示此节点接口监听的地址，最后监听在0.0.0.0，所以其它节点就都可以访问他
discovery.zen.ping.unicast.hosts: ["172.16.10.10:9300"] 表示集群用于主节点的发现地址，这里需要注意的是，配置的IP不只是单纯的节点发现，而是用于主节点的发现
discovery.zen.minimum_master_nodes: 1 表示最少要有多少个主节点再能启动，默认是3个，当集群不大时，只需要配置一个就好 
```

### elasticsearch:5.6.10-alpine镜像的内存设置参数ES_JAVA_OPTS或者jvm.options
```
# 第一种全局配置ES_JAVA_OPTS参数
docker run -it --rm -e ES_JAVA_OPTS="-Xms256m -Xmx256m" elasticsearch:5.6.10-alpine
# 第二种修改/usr/share/elasticsearch/config/jvm.options配置文件，修改里面的 -Xms2g -Xmx2g 参数
```

```
docker stop single-elasticsearch
docker rm single-elasticsearch
docker network rm elasticsearch-network
docker network create --subnet=10.101.57.0/24 elasticsearch-network
docker run -itd --restart always --net elasticsearch-network --ip 10.101.57.101 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" --name single-elasticsearch elasticsearch:5.6.10-alpine
```