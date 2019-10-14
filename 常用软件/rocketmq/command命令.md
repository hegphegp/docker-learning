```
mkdir -p /opt/soft/rocketmq/logs/nameserver-a
mkdir -p /opt/soft/rocketmq/logs/nameserver-b
mkdir -p /opt/soft/rocketmq/store/nameserver-a
mkdir -p /opt/soft/rocketmq/store/nameserver-b
mkdir -p /opt/soft/rocketmq/logs/broker-a
mkdir -p /opt/soft/rocketmq/logs/broker-b
mkdir -p /opt/soft/rocketmq/store/broker-a
mkdir -p /opt/soft/rocketmq/store/broker-b
mkdir -p /opt/soft/rocketmq/broker-a/
mkdir -p /opt/soft/rocketmq/broker-b/

# rocke有9876
# 非vip通道端口:10911
# vip通道端口:10909
# 10909是VIP通道对应的端口，在JAVA中的消费者对象或者是生产者对象中关闭VIP通道即可无需开放10909端口


tee /opt/soft/rocketmq/broker-a/broker-a.conf <<-'EOF'
brokerClusterName = rocketmq-cluster
brokerName = broker-a
brokerId = 0
# 这个ip配置为内网访问，让mq只能内网访问,不配置默认为内网
# brokerIP1 = 172.16.21.17
deleteWhen = 04
fileReservedTime = 48
# 要互联网连接, 要用公网IP
namesrvAddr=172.16.21.15:9876;172.16.21.16:9876
autoCreateTopicEnable=true
#Broker 对外服务的监听端口,
listenPort = 10911
#Broker角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE
brokerRole=ASYNC_MASTER
#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘
flushDiskType=ASYNC_FLUSH
EOF



tee /opt/soft/rocketmq/broker-b/broker-b.conf <<-'EOF'
brokerClusterName = rocketmq-cluster
brokerName = broker-b
brokerId = 0
# 这个ip配置为内网访问，让mq只能内网访问,不配置默认为内网
# brokerIP1 = 172.16.21.18
deleteWhen = 04
fileReservedTime = 48
# 要互联网连接, 要用公网IP
namesrvAddr=172.16.21.15:9876;172.16.21.16:9876
autoCreateTopicEnable=true
# Broker 对外服务的监听端口,
listenPort = 10911
#Broker角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE
brokerRole=ASYNC_MASTER
#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘
flushDiskType=ASYNC_FLUSH
EOF
```