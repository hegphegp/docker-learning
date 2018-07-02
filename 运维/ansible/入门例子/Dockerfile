FROM alpine:3.7

RUN echo "http://mirrors.aliyun.com/alpine/v3.7/main" > /etc/apk/repositories ; \
    echo "http://mirrors.aliyun.com/alpine/v3.7/community" >> /etc/apk/repositories

RUN apk add --update openssh python2

# 不删除 rm -rf /var/cache/apk/*
RUN echo 'root:root' | chpasswd ; \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config ; \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config ; \
    ssh-keygen -A ; \
    rm -rf /tmp/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]