
# 血的教训:echo '''''后面不能换行，不能有空格，要直接接内容，否则输出的文件第一行是空行，导致docker-entrypoint.sh文件第一行是空行的话，alpine执行抛 standard_init_linux.go:207: exec user process caused "exec format error" 错误
```
docker rmi openvpn:2.4.6-r3
mkdir -p openvpn-2.4.6-r3 && cd openvpn-2.4.6-r3
echo '''''FROM alpine:3.8
RUN echo "http://mirrors.aliyun.com/alpine/v3.8/main" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/v3.8/community" >> /etc/apk/repositories && \
    apk update && apk --no-cache --no-progress add bash openvpn=2.4.6-r3 && \
    rm -rf /tmp/*

COPY docker-entrypoint.sh /usr/bin

RUN chmod a+x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
''''' > Dockerfile

echo '''''#!/usr/bin/env bash

set -e

#通过-e环境变量来设置配置文件参数
if [ -z "$USERNAME" ]; then
  echo -e '\033[31m 必须配置USERNAME用户账号参数 \033[0m'
  exit 2
fi

if [ -z "$PASSWORD" ]; then
  echo -e '\033[31m 必须配置PASSWORD密码参数 \033[0m'
  exit 2
fi

if [ -z "$CONFIG_FILE_NAME" ]; then
  echo -e '\033[31m 必须配置CONFIG_FILE_NAME文件名参数 \033[0m'
  exit 2
fi

mkdir -p /etc/openvpn
echo "$USERNAME" > /etc/openvpn/auth.txt
echo "$PASSWORD" >> /etc/openvpn/auth.txt
chmod 0600 /etc/openvpn/auth.txt
cd /openvpn
openvpn --config ${CONFIG_FILE_NAME} --auth-user-pass /etc/openvpn/auth.txt --auth-nocache ${OPENVPN_OPTS}
''''' > docker-entrypoint.sh

docker build -t openvpn:2.4.6-r3 .
cd .. && rm -rf openvpn-2.4.6-r3

docker run -itd --privileged --net=host --name openvpn -e USERNAME=aaa -e PASSWORD="Aaaa\$123" -e CONFIG_FILE_NAME=client.ovpn -v /opt/soft/openvpn-client:/openvpn openvpn:2.4.6-r3
# docker run -itd --privileged --net=host --name openvpn -e USERNAME=aaa -e PASSWORD='Aaaa$123' -e CONFIG_FILE_NAME=client.ovpn -v /opt/soft/openvpn-client:/openvpn openvpn:2.4.6-r3

docker logs -f --tail=300 openvpn
```