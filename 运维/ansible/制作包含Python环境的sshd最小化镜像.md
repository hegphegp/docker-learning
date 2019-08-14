# 制作包含Python环境的sshd最小化镜像

#### Dockerfile文件
```
FROM alpine:3.7

ENV ROOT_PASSWORD root

RUN echo "http://mirrors.aliyun.com/alpine/v3.7/main" > /etc/apk/repositories ; \
    echo "http://mirrors.aliyun.com/alpine/v3.7/community" >> /etc/apk/repositories

RUN apk add --update openssh python2

RUN echo "root:${ROOT_PASSWORD}" | chpasswd ; \
    sed -ri "s/^#?PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config ; \
    sed -ri "s/UsePAM yes/#UsePAM yes/g" /etc/ssh/sshd_config ; \
    ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa -q ; \
    rm -rf /var/cache/apk/* /tmp/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
```

#### 构造命令
```
docker build -t sshd .
```