## 制作Centos的sshd镜像

#### 有很多坑，但是无法一一写明。用一天生命换来的：人生要去接受无奈，用再多的生命时间去解决这些问题就是找挂掉
* 容器里使用systemctl可能抛错：Failed to get D-Bus connection: Operation not permitted，原因是dbus-daemon没启动，解决方法：docker run 加 --privileged 参数，同时CMD或者entrypoint.sh设置 /usr/sbin/init，docker容器会自动将dbus等服务启动起来
* centos:7镜像中，如果容器启动命令用了 /usr/sbin/init ，就不要有 docker-entrypoint.sh ，好像docker-entrypoint.sh会影响到 /usr/sbin/init 的运行
* 在centos:7镜像中 docker-entrypoint.sh 中存在 /usr/sbin/init 容器启动就会挂掉
* docker run --privileged -it -d centos:7.6.1810 /usr/sbin/init  不加 -d 参数，容器启动就是挂掉
```
##### 制作Dockerfile文件

tee Dockerfile <<-'EOF'
FROM centos:7.6.1810

ENV ROOT_PASSWORD root

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo ; \
    echo "export LC_ALL=en_US.UTF-8" >> /etc/profile ; \
    yum install -y openssh-server openssh-clients firewalld git; \
    ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa -q ; \
    echo "root:${ROOT_PASSWORD}" | chpasswd ; \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config; \
    sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config; \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    yum clean all  ; \
    git clone https://www.baidu.com; \
    

EXPOSE 22

CMD ["/usr/sbin/init"]
EOF

##### 制作Dockerfile文件结束

docker build -t centos-sshd:7.6.1810 .

# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' centos-sshd1
# # 172.17.0.2
# ssh root@172.17.0.2
```


```
docker pull williamyeh/ansible:alpine3
docker tag williamyeh/ansible:alpine3 ansible-2.5

mkdir -p /opt/soft/ansible
tee /opt/soft/ansible/ansible.cfg <<-'EOF'
[defaults]
host_key_checking = False
# ansible 执行命令的目录就是 ./ ，所以必须运行命令时，必须先进入ansible项目路径，否则出错不好处理
inventory = ./host
EOF

tee /opt/soft/ansible/host <<-'EOF'
[web]
10.10.58.101 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
10.10.58.102 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
10.10.58.103 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
EOF

docker stop web1 web2 web3 ansible
docker rm web1 web2 web3 ansible
docker network rm ansible-network
docker network create --subnet=10.10.58.0/24 ansible-network

docker run --privileged -itd --restart always --net ansible-network --ip 10.10.58.100 --name ansible -v /opt/soft/ansible:/ansible ansible-2.5 sh
docker run --privileged -itd --restart always --net ansible-network --ip 10.10.58.101 --name web1 centos-sshd:7.6.1810 /usr/sbin/init
docker run --privileged -itd --restart always --net ansible-network --ip 10.10.58.102 --name web2 centos-sshd:7.6.1810 /usr/sbin/init
docker run --privileged -itd --restart always --net ansible-network --ip 10.10.58.103 --name web3 centos-sshd:7.6.1810 /usr/sbin/init
docker exec -it ansible sh
cd /ansible
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa -q
# state取值 present 表示添加；取值 absent 表示删除 ，没有则创建authorized_keys文件
ansible web -m authorized_key -a "user=root state=present key='{{ lookup('file', '/root/.ssh/id_rsa.pub') }} '"
ansible web -m authorized_key -a "user=root state=present key='{{ lookup('file', '/root/.ssh/id_rsa.pub')}}' path='/root/.ssh/authorized_keys' manage_dir=no"

```