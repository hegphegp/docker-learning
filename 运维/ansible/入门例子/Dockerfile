FROM python:2.7-alpine3.7

RUN echo "http://mirrors.aliyun.com/alpine/v3.7/main" > /etc/apk/repositories ; \
    echo "http://mirrors.aliyun.com/alpine/v3.7/community" >> /etc/apk/repositories

RUN apk add --update ; \
    apk add openssh ;

RUN echo 'root:root' |chpasswd ; \
    sed -i 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config ; \
    sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config ; \
    ssh-keygen -A ; \
    rm -rf /var/cache/apk/* && rm -rf /tmp/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]