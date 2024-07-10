### graalvm的docker镜像制作

* graalvm下载地址

```
# https://www.oracle.com/java/technologies/javase/graalvm-jdk21-archive-downloads.html
# https://www.oracle.com/java/technologies/javase/graalvm-jdk17-archive-downloads.html

wget https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_linux-x64_bin.tar.gz
wget https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.10_linux-x64_bin.tar.gz

```

* 如果ubuntu/centos每个版本都制作一个graalvm镜像，graalvm又区分jdk11,jdk17,jdk21的话，镜像个数会非常多，因此制作一个镜像把jdk17，jdk21加进去，下载镜像就可以把graalvm下载下来，到时候Ubuntu/Centos容器直接挂载对应的graalvm目录，就拥有graalvm配置环境

```

## 制作graalvm镜像包含多个graalvm

wget https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_linux-x64_bin.tar.gz
wget https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.10_linux-x64_bin.tar.gz
wget https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz

tee Dockerfile <<-'EOF'
FROM alpine:3.9.6

RUN mkdir -p /opt/soft/docker-env/graalvm/

ADD graalvm-jdk-21.0.2_linux-x64_bin.tar.gz /opt/soft/docker-env/graalvm/

ADD graalvm-jdk-17.0.10_linux-x64_bin.tar.gz /opt/soft/docker-env/graalvm/

EOF

docker build -t graalvm:17-21 .

docker run -itd --name graalvm graalvm:17-21-20240710 sh
mkdir -p /opt/soft/docker-env/graalvm/
docker cp graalvm:/opt/soft/docker-env/graalvm/ /opt/soft/docker-env/graalvm/
docker stop graalvm
docker rm graalvm




tee Dockerfile <<-'EOF'
FROM ubuntu:18.04

RUN mkdir -p /opt/soft/maven && mkdir -p /etc/profile.d/ && mkdir -p /root/.m2/ && \
    echo "#set maven environment" > /etc/profile.d/maven.sh && \
    echo "export MAVEN_HOME=/opt/soft/maven/apache-maven-3.9.8" >> /etc/profile.d/maven.sh && \
    echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile.d/maven.sh && \
    chmod 755 /etc/profile.d/maven.sh

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven

ADD settings.xml /root/.m2/

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && apt-get clean all && apt-get install -y gcc zlib1g-dev build-essential libz-dev

EOF

docker build -t ubuntu:18.04-graalvm .

echo "#set graalvm environment" > java.sh && \
    echo "export JAVA_HOME=/opt/soft/graalvm/docker/graalvm-jdk-21.0.2+13.1/" >> java.sh && \
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> java.sh && \
    chmod 755 java.sh


docker run -itd --name graalvm -v "$PWD/springboot3-native-test":/springboot3-native-test -v "/root/.m2/repository":/root/.m2/repository ubuntu:18.04-graalvm bash

docker exec -it graalvm bash 
source /etc/profile
java -version

## 
```

#### 推动线上的镜像是
```
docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:17-21-20240710
```


