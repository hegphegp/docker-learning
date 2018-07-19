# elasticsearch

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
#### elasticsearch高版本支持json和yml格式的配置文件，将config/elasticsearch.yml改成config/elasticsearch.json或者config/elasticsearch.json改成config/elasticsearch.yml就可以了
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

### ES Restful API GET、POST、PUT、DELETE、HEAD含义 
```
# 1）GET：获取请求对象的当前状态。 
# 2）POST：改变对象的当前状态(新增或者修改对象内容)。 
# 3）PUT：创建一个对象集合(数据表)。 
# 4）DELETE：销毁对象。 
# 5）HEAD：请求获取对象的基础信息。

# curl的设置请求格式的参数 -H "accept: application/xml" -H "Content-Type: application/json"
 
# 不带请求体
curl -X PUT http://10.101.57.101:9200/school
# 带请求体的
curl -X PUT http://10.101.57.101:9200/student -d '{"username":"username","age":12}'
curl -X GET http://10.101.57.101:9200/school
# curl -X POST http://10.101.57.101:9200/school/person -H "accept: application/xml" -H "Content-Type: application/json" -d '{"username":"username","age":12}'
curl -X POST http://10.101.57.101:9200/school/person -d '{"username":"username","age":12}'
# HEAD请求是没有响应体，用下面这条命令，客户端会卡住等待读取请求体的内容
# curl -X HEAD http://10.101.57.101:9200/school
curl -X -I/--head http://10.101.57.101:9200/school
curl -X DELETE http://10.101.57.101:9200/school
```

### elasticsearch知识点
* elasticsearch不需要手动创建索引，Everything is indexed，需要手动设置索引类型
* 在关系型数据库中，需要先创建database和table后才可以插入数据。而在es可以直接插入数据，系统会自动建立缺失的index和doc type，并对字段建立mapping。因为半结构化数据的数据结构通常是动态变化的，无法预知某个文档中是否有哪些字段，如果每次插入数据都需要提前建立index、type、mapping，那就失去了其作为NoSQL的优势了。
* 但是es自动创建的mapping不是万能的，有时候需要根据实际情况自定义Mapping。例如，es默认的中文分词是一个字一个字分的，因此要建立引入第三方的es中文分词插件，自定义中文分词的Mapping
* es默认的Mapping不是万能的，因为有些字段是不需要索引的，es默认给每个字段创建索引，会消耗CPU，内存和硬盘空间

### elasticsearch与PostgreSQL的对比
PostgreSQL | elasticsearch
:---:|:---:
Database | Index
Table | Type
Row | Document
Column | Field
Schema | Mapping
Index | Everything is indexed
SQL | Query DSL
SELECT * FROM table ... | GET http://...
UPDATE table SET ... | PUT http://...
