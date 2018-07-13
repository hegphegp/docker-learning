# zookeeper单节点部署和使用

```
docker stop single-zookeeper
docker rm single-zookeeper
docker network rm zookeeper-network
docker network create --subnet=10.100.57.0/24 zookeeper-network
docker run --restart always -itd \
    --name single-zookeeper \
    --net zookeeper-network \
    --ip 10.100.57.101 \
    -e ZOO_CONF_DIR=/conf \
    -e ZOO_DATA_DIR=/data \
    -e ZOO_DATA_LOG_DIR=/datalog \
    -e ZOO_PORT=2181 \
    -e ZOO_TICK_TIME=2000 \
    -e ZOO_INIT_LIMIT=5 \
    -e ZOO_SYNC_LIMIT=2 \
    -e ZOO_MAX_CLIENT_CNXNS=60 \
     zookeeper:3.4.12
```