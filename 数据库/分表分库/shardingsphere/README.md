####  docker部署
##### 官方代码仓库的sharding-proxy的Dockerfile文件
* 官方仓库的sharding-proxy的Dockerfile路径  https://github.com/apache/incubator-shardingsphere/blob/master/sharding-distribution/sharding-proxy-distribution/src/main/docker/Dockerfile
```
tee Dockerfile <<-'EOF'
FROM openjdk:8u212-jre-alpine3.9
MAINTAINER ShardingSphere "dev@shardingsphere.incubator.apache.org"

ENV CURRENT_VERSION 4.0.1
ENV APP_NAME apache-shardingsphere-incubating
ENV MODULE_NAME sharding-proxy
ENV LOCAL_PATH /opt/sharding-proxy

RUN wget https://dist.apache.org/repos/dist/release/incubator/shardingsphere/${CURRENT_VERSION}/${APP_NAME}-${CURRENT_VERSION}-${MODULE_NAME}-bin.tar.gz && \
    tar -xzvf ${APP_NAME}-${CURRENT_VERSION}-${MODULE_NAME}-bin.tar.gz && \
    mv ${APP_NAME}-${CURRENT_VERSION}-${MODULE_NAME}-bin ${LOCAL_PATH} && \
    rm -f ${APP_NAME}-${CURRENT_VERSION}-${MODULE_NAME}-bin.tar.gz

ENTRYPOINT /opt/sharding-proxy/bin/start.sh $PORT && tail -f /opt/sharding-proxy/logs/stdout.log
EOF
docker build -t sharding-proxy:4.0.1 .
```










#### 下面的笔记比较凌乱
##### 官方给的通过代码打包docker镜像的例子，这种方式网络要能访问到国外
* 必须在shardingsphere项目根目录用mvn install打包， 才可以到sharding-proxy-distribution目录打包docker镜像，否则提示依赖包
```
git clone https://github.com/apache/incubator-shardingsphere
mvn clean install
# 上面打包命令，居然有下载node.tar.gz和npm.tar.gz安装包的命令行输出，不能访问外网，卡了很长时间，最终强行中断打包

# [INFO] Installing node version v6.10.0
# [INFO] Downloading https://nodejs.org/dist/v6.10.0/node-v6.10.0-linux-x64.tar.gz to /home/hgp/.m2/repository/com/github/eirslett/node/6.10.0/node-6.10.0-linux-x64.tar.gz
# [INFO] No proxies configured
# [INFO] No proxy was configured, downloading directly
# [INFO] Unpacking /home/hgp/.m2/repository/com/github/eirslett/node/6.10.0/node-6.10.0-linux-x64.tar.gz into /home/hgp/aa/incubator-shardingsphere-4.0.1/sharding-ui/sharding-ui-frontend/node/tmp
# [INFO] Copying node binary from /home/hgp/aa/incubator-shardingsphere-4.0.1/sharding-ui/sharding-ui-frontend/node/tmp/node-v6.10.0-linux-x64/bin/node to /home/hgp/aa/incubator-shardingsphere-4.0.1/# sharding-ui/sharding-ui-frontend/node/node
# [INFO] Installed node locally.
# [INFO] Installing npm version 3.10.10
# [INFO] Downloading https://registry.npmjs.org/npm/-/npm-3.10.10.tgz to /home/hgp/.m2/repository/com/github/eirslett/npm/3.10.10/npm-3.10.10.tar.gz
# [INFO] No proxies configured
# [INFO] No proxy was configured, downloading directly
# [INFO] Unpacking /home/hgp/.m2/repository/com/github/eirslett/npm/3.10.10/npm-3.10.10.tar.gz into /home/hgp/aa/incubator-shardingsphere-4.0.1/sharding-ui/sharding-ui-frontend/node/node_modules

cd sharding-sphere/sharding-distribution/sharding-proxy-distribution
mvn clean package docker:build
```