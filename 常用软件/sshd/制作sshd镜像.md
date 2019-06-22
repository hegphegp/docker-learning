#### 制作sshd镜像

echo '''''
FROM alpine:3.8

ENV USER test
ENV USER_PASSWORD test
ENV ROOT_PASSWORD root

RUN echo "http://mirrors.aliyun.com/alpine/v3.8/main" > /etc/apk/repositories ; \
    echo "http://mirrors.aliyun.com/alpine/v3.8/community" >> /etc/apk/repositories ; \
    apk add --update openssh shadow bash ; \
	ssh-keygen -A ; \
	rm -rf /var/cache/apk/* /tmp/*

COPY docker-entrypoint.sh /usr/bin

RUN chmod a+x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
''''' > Dockerfile

echo '''''#!/usr/bin/env bash

if [ ! -d "/etc/config/has-config" ]; then
    echo -e "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd root ;
    sed -ri "s|^#?MaxAuthTries\s+.*|MaxAuthTries 20|" /etc/ssh/sshd_config ;
    sed -ri "s|UsePAM yes|#UsePAM yes|g" /etc/ssh/sshd_config ;

    useradd $USER -d /home/$USER -m ; \
    echo -e "$USER_PASSWORD\n$USER_PASSWORD" | passwd $USER ;
    echo "AllowUsers $USER" >> /etc/ssh/sshd_config ;
    mkdir -p /etc/config/has-config
fi

# 下面的命令是为了不让 docker-entrypoint.sh 脚本退出，因为容器 docker-entrypoint.sh脚本执行结束的话，会不断重启，进入死循环
exec "$@"
''''' > docker-entrypoint.sh


docker stop alpine-sshd
docker rm alpine-sshd
docker rmi alpine-sshd:3.8
docker build -t alpine-sshd:3.8 .

docker run -itd --restart always -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro --name alpine-sshd -e ROOT_PASSWORD='root' -e USER=test -e USER_PASSEORD='test' -p 39279:22 alpine-sshd:3.8
