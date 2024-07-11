### graalvm的docker镜像制作

* graalvm下载地址

```
# https://www.oracle.com/java/technologies/javase/graalvm-jdk21-archive-downloads.html
# https://www.oracle.com/java/technologies/javase/graalvm-jdk17-archive-downloads.html

wget https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_linux-x64_bin.tar.gz
wget https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.10_linux-x64_bin.tar.gz

```

#### graalvm打包需要依赖 gcc zlib1g-dev build-essential libz-dev 软件

```
tee Dockerfile <<-'EOF'
FROM ubuntu:18.04

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && apt-get clean all && apt-get install -y gcc zlib1g-dev build-essential libz-dev && apt-get clean && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EOF

docker build -t ubuntu:18.04-gcc .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:20.04

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && apt-get clean all && apt-get install -y gcc zlib1g-dev build-essential libz-dev && apt-get clean && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EOF

docker build -t ubuntu:20.04-gcc .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:22.04

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && apt-get clean all && apt-get install -y gcc zlib1g-dev build-essential libz-dev && apt-get clean && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EOF

docker build -t ubuntu:22.04-gcc .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:24.04

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && apt-get clean all && apt-get install -y gcc zlib1g-dev build-essential libz-dev && apt-get clean && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EOF

docker build -t ubuntu:24.04-gcc .

```

#### 制作graalvm镜像

```

wget https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_linux-x64_bin.tar.gz
wget https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.10_linux-x64_bin.tar.gz
wget https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz

# 配置阿里maven加速仓库

tee Dockerfile <<-'EOF'
FROM ubuntu:18.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-17.0.10+11.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-17.0.10_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:18.04-graalvm-jdk-17 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:20.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-17.0.10+11.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-17.0.10_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:20.04-graalvm-jdk-17 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:22.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-17.0.10+11.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-17.0.10_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:22.04-graalvm-jdk-17 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:24.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-17.0.10+11.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-17.0.10_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:24.04-graalvm-jdk-17 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:18.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-21.0.2+13.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-21.0.2_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:18.04-graalvm-jdk-21 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:20.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-21.0.2+13.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-21.0.2_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:20.04-graalvm-jdk-21 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:22.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-21.0.2+13.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-21.0.2_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:22.04-graalvm-jdk-21 .


#############################################停止COPY#############################################

tee Dockerfile <<-'EOF'
FROM ubuntu:24.04-gcc

ENV JAVA_HOME /opt/soft/graalvm/graalvm-jdk-21.0.2+13.1
ENV MAVEN_HOME /opt/soft/maven/apache-maven-3.9.8
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

ADD apache-maven-3.9.8-bin.tar.gz /opt/soft/maven
ADD graalvm-jdk-21.0.2_linux-x64_bin.tar.gz /opt/soft/graalvm/
ADD settings.xml /opt/soft/maven/apache-maven-3.9.8/conf

EOF

docker build -t graalvm:24.04-graalvm-jdk-21 .


#############################################停止COPY#############################################


docker run -itd --name graalvm -v "$PWD/springboot3-native-test":/springboot3-native-test -v "/root/.m2/repository":/root/.m2/repository graalvm:22.04-graalvm-jdk-21 bash

docker run -itd --name graalvm -v "$PWD/springboot3-native-test":/springboot3-native-test -v "/root/.m2/repository":/root/.m2/repository graalvm:18.04-graalvm-jdk-17 bash


```

#### 推动线上的镜像是
```
docker tag graalvm:18.04-graalvm-jdk-17 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:18.04-graalvm-jdk-17
docker tag graalvm:20.04-graalvm-jdk-17 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:20.04-graalvm-jdk-17
docker tag graalvm:22.04-graalvm-jdk-17 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:22.04-graalvm-jdk-17
docker tag graalvm:24.04-graalvm-jdk-17 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:24.04-graalvm-jdk-17

docker tag graalvm:18.04-graalvm-jdk-21 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:18.04-graalvm-jdk-21
docker tag graalvm:20.04-graalvm-jdk-21 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:20.04-graalvm-jdk-21
docker tag graalvm:22.04-graalvm-jdk-21 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:22.04-graalvm-jdk-21
docker tag graalvm:24.04-graalvm-jdk-21 registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:24.04-graalvm-jdk-21


docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:18.04-graalvm-jdk-17

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:20.04-graalvm-jdk-17

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:22.04-graalvm-jdk-17

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:24.04-graalvm-jdk-17

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:18.04-graalvm-jdk-21

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:20.04-graalvm-jdk-21

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:22.04-graalvm-jdk-21

docker push registry.cn-hangzhou.aliyuncs.com/hegp/graalvm:24.04-graalvm-jdk-21

```


