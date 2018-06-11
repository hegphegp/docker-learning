FROM java:8u111-jdk-alpine

# 有个坑，https://mirrors.aliyun.com只保留最新的两个版本，可能导致ant下载和tomcat下载抛404错误
# alpine自带的wget工具没有 --no-check-certificate --no-cookies 这些参数，必须安装新版本才有apk add --no-cache wget
# draw.io在线下载很慢，实现下载到本地，下载地址 https://github.com/jgraph/drawio/releases, https://codeload.github.com/jgraph/drawio/zip/v8.7.0
# https://github.com/jgraph/draw.io/archive/v8.7.6.tar.gz, https://github.com/jgraph/draw.io/archive/v8.7.6.zip, https://github.com/jgraph/drawio/releases/download/v8.7.6/draw.war
# 解压命令 unzip -d 参数，解压路径不存在会自动创建
# wget https://github.com/jgraph/draw.io/archive/v${DRAW_VERSION}.tar.gz

ENV DRAW_VERSION=8.7.6
ENV ANT_VERSION=1.10.3
ENV TOMCAT_VERSION=8.5.31
ENV TOMCAT_HOME=/opt/tomcat
ENV PATH=$PATH:$TOMCAT_HOME/bin

ADD ./drawio-8.7.6.tar.gz /

RUN wget http://mirrors.aliyun.com/apache/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz ; \
    wget http://mirrors.aliyun.com/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz ; \
    mkdir -p /opt ; \
    tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ ; \
    tar -zvxf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/ ; \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat ; \
    cd /drawio-${DRAW_VERSION}/etc/build ; \
    /opt/apache-ant-${ANT_VERSION}/bin/ant war ; \
    rm -rf $TOMCAT_HOME/webapps ; \
    mkdir -p $TOMCAT_HOME/webapps/ROOT ; \
    unzip /drawio-${DRAW_VERSION}/build/draw.war -d $TOMCAT_HOME/webapps/ROOT ; \
    rm -rf /apache-ant-${ANT_VERSION}-bin.tar.gz ; \
    rm -rf /apache-tomcat-${TOMCAT_VERSION}.tar.gz ; \
    rm -rf /opt/apache-ant-${ANT_VERSION} ; \
    rm -rf /drawio-${DRAW_VERSION}

EXPOSE 8080
CMD ["catalina.sh", "run"]
