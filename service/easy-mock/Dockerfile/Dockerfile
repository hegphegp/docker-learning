FROM ubuntu:16.04

RUN echo "# deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted" > /etc/apt/sources.list; \
    echo "deb-src http://archive.ubuntu.com/ubuntu xenial main restricted" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted" >> /etc/apt/sources.list; \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted" >> /etc/apt/sources.list; \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial universe" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted" >> /etc/apt/sources.list; \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse" >> /etc/apt/sources.list;

RUN apt-get update && apt-get install --no-install-recommends -y wget jq ca-certificates; \
    wget http://cdn.npm.taobao.org/dist/node/v8.4.0/node-v8.4.0-linux-x64.tar.gz / ; \
    tar -xzvf node-v8.4.0-linux-x64.tar.gz -C / ; \
    ln -s /node-v8.4.0-linux-x64/bin/node /usr/local/bin/node; \
    ln -s /node-v8.4.0-linux-x64/bin/npm /usr/local/bin/npm; \
    mkdir /easy-mock ; \
    wget https://github.com/easy-mock/easy-mock/archive/v1.5.1.tar.gz / ; \
    tar -xzvf v1.5.1.tar.gz -C /easy-mock --strip-components 1 ; \
    npm config set registry https://registry.npm.taobao.org; \
    cd /easy-mock ; \
    cp config/default.json config/production.json; \
    npm install -verbose && npm run build ; \
    apt-get remove -y wget ca-certificates ; \
    apt-get autoclean && apt-get clean && apt-get autoremove ; \
    rm -rf /node-v8.4.0-linux-x64.tar.gz; \ 
    rm -rf /v1.5.1.tar.gz ;

WORKDIR /easy-mock
EXPOSE 7300

COPY docker-entrypoint.sh /usr/bin/
RUN chmod a+x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "npm", "start", "-verbose" ]
