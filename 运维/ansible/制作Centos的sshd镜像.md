## 制作Centos的sshd镜像

#### 有很多坑，但是无法一一写明。用一天生命换来的：人生要去接受无奈，用再多的生命时间就是找死
* centos:7镜像中，如果容器启动命令用了 /usr/sbin/init ，就不要有 docker-entrypoint.sh ，好像docker-entrypoint.sh会影响到 /usr/sbin/init 的运行
* 在centos:7镜像中 docker-entrypoint.sh 中存在 /usr/sbin/init 容器启动就会死
* docker run --privileged -it -d centos:7.6.1810 /usr/sbin/init  不加 -d 参数，容器启动就是死
```
mkdir -p centos-7.6.1810-sshd
cd centos-7.6.1810-sshd

##### 制作Dockerfile文件
tee Dockerfile <<-'EOF'
FROM centos:7.6.1810

ENV ROOT_PASSWORD root

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo ; \
    echo "export LC_ALL=en_US.UTF-8" >> /etc/profile ; \
    yum install -y openssh-server openssh-clients firewalld ; \
    ssh-keygen -A ; \
    echo "root:${ROOT_PASSWORD}" | chpasswd ; \
    echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" >> /etc/resolv.conf ; \
    sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
    sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    yum clean all

EXPOSE 22

CMD ["/usr/sbin/init"]
EOF
##### 制作Dockerfile文件结束

docker build -t centos-sshd:7.6.1810 .

# docker run --privileged -itd --name centos-sshd1 centos-sshd:7.6.1810 /usr/sbin/init
# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' centos-sshd1
# # 172.17.0.2
# ssh root@172.17.0.2
```