# Redis-cluster集群搭建.md
> 挺无奈的现实,redis官方没有提供redis-trib的镜像,只能通过下载官方的源码包解压获取redis-trib.rb文件来制作镜像

##### 制作redis-trib镜像的Dockerfile文件
```
FROM ruby:2.5-alpine3.7
RUN echo "http://mirrors.aliyun.com/alpine/v3.7/main" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/v3.7/community" >> /etc/apk/repositories
RUN gem install redis:4.0.1; \
    apk add --no-cache curl; \
    apk add --no-cache tar; \
    curl http://download.redis.io/releases/redis-4.0.9.tar.gz -s -o /redis-4.0.9.tar.gz; \
    tar -zxvf /redis-4.0.9.tar.gz -C / ; \
    cp /redis-4.0.9/src/redis-trib.rb /usr/bin; \
    chmod +x /usr/bin/redis-trib.rb; \
    rm -rf /redis-4.0.9; \
    rm -rf /redis-4.0.9.tar.gz; \
    apk del tar; \
    apk del curl

CMD ["sh"]
```

```
docker build -t redis-trib:4.0.9-alpine .
```

###启动多个redis实例
```
# 用docker加上配置参数跑redis服务时,不能加--daemonize yes, 该参数为yes时, 表示以后台形式运行redis, 但是容器检测不到后台运行的程序的状况, 以为redis挂掉了, 容器就会退出
docker network rm redis-network
docker network create --subnet=10.10.57.0/24 redis-network
docker stop redis1
docker rm redis1
docker run -itd --name redis1 --net redis-network --ip 10.10.57.101 --restart always redis:4.0.9-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled no \
--bind 0.0.0.0 \
--requirepass admin
docker logs redis1

docker stop redis2
docker rm redis2
docker run -itd --name redis2 --net redis-network --ip 10.10.57.102 --restart always redis:4.0.9-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled no \
--bind 0.0.0.0 \
--requirepass admin
docker logs redis2

docker stop redis3
docker rm redis3
docker run -itd --name redis3 --net redis-network --ip 10.10.57.103 --restart always redis:4.0.9-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled no \
--bind 0.0.0.0 \
--requirepass admin
docker logs redis3

docker stop redis4
docker rm redis4
docker run -itd --name redis4 --net redis-network --ip 10.10.57.104 --restart always redis:4.0.9-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled no \
--bind 0.0.0.0 \
--requirepass admin
docker logs redis4

docker stop redis5
docker rm redis5
docker run -itd --name redis5 --net redis-network --ip 10.10.57.105 --restart always redis:4.0.9-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled no \
--bind 0.0.0.0 \
--requirepass admin
docker logs redis5

docker stop redis6
docker rm redis6
docker run -itd --name redis6 --net redis-network --ip 10.10.57.106 --restart always redis:4.0.9-alpine redis-server \
--port 6379  \
--protected-mode no \
--pidfile redis.pid \
--appendonly yes \
--cluster-enabled no \
--bind 0.0.0.0 \
--requirepass admin
docker logs redis6
```

```
docker run -itd --name redis-trib --net redis-network --ip 10.10.57.90 --restart always redis-trib:4.0.9 sh
```

##### 集群设置密码，那么requirepass和masterauth都需要设置
```
docker stop redis-trib
docker stop redis1
docker stop redis2
docker stop redis3
docker stop redis4
docker stop redis5
docker stop redis6
docker rm redis-trib
docker rm redis1
docker rm redis2
docker rm redis3
docker rm redis4
docker rm redis5
docker rm redis6
```