# elasticsearch单节点

### elasticsearch:5.6.10-alpine镜像的参数说明
```
# elasticsearch:5.6.10-alpine这个版本的镜像的数据保存目录和日志目录是
# 数据目录
/usr/share/elasticsearch/data
# 日志目录
/usr/share/elasticsearch/logs
```

### elasticsearch的5.6.10版本的内存设置参数ES_JAVA_OPTS或者jvm.options
```
docker run -it --rm -e ES_JAVA_OPTS="-Xms256m -Xmx256m" elasticsearch:5.6.10-alpine
# 用 -e 在docker设置 -e JVM_OPTIONS="-Xms256m -Xmx256m" 没效果
# docker run -it --rm -e JVM_OPTIONS="-Xms256m -Xmx256m" elasticsearch:5.6.10-alpine
```

```
docker stop single-elasticsearch
docker rm single-elasticsearch
docker network rm elasticsearch-network
docker network create --subnet=10.101.57.0/24 elasticsearch-network
docker run -itd --restart always --net elasticsearch-network --ip 10.101.57.101 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" --name single-elasticsearch elasticsearch:5.6.10-alpine
```