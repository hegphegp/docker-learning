## Ubuntu-16.04 sh脚本安装docker,docker-compose,docker-machine

[16.04-Xenial的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/xenial/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/xenial/pool/edge/amd64/)  
[16.10-Yakkety的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/yakkety/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/yakkety/pool/edge/amd64/)  
[17.04-Zesty的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/zesty/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/zesty/pool/edge/amd64/)  
[17.10-Artful的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/artful/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/artful/pool/edge/amd64/)  
[18.04-Bionic的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/edge/amd64/)  
[docker-compose的官方下载地址https://github.com/docker/compose/releases/](https://github.com/docker/compose/releases/)  
[docker-compose的官方下载地址https://mirrors.aliyun.com/docker-toolbox/linux/compose/](https://mirrors.aliyun.com/docker-toolbox/linux/compose/)  
[docker-machine的官方下载地址https://github.com/docker/machine/releases/](https://github.com/docker/machine/releases)  
[docker-machine的官方下载地址https://mirrors.aliyun.com/docker-toolbox/linux/machine/](https://mirrors.aliyun.com/docker-toolbox/linux/machine/)  


```shell
#!/bin/bash

# 定义变量
PASSWD=admin
DOCKER_VERSION=docker-ce_18.03.0-ce-0-ubuntu_amd64.deb
DOCKER_USER=hgp

# 安装版本 docker-ce_18.03.0-ce-0-ubuntu_amd64.deb, docker-compose-Linux-x86_64-1.16.1, docker-machine-Linux-x86_64-0.13.0
# 适用于ubuntu-16.04
# ubuntu脚本自动输入sudo密码
# sudo后面都有用到参数 -S
# ubuntu-16.04安装高版本docker-ce_17.12.0~ce-0~ubuntu_amd64.deb以上版本，必须安装依赖　sudo apt-get install -y libltdl7 libseccomp2

echo $PASSWD | sudo -S apt-get remove -y docker docker-engine docker.io docker-ce
echo $PASSWD | sudo -S apt-get install -y libltdl7 libseccomp2
echo $PASSWD | sudo -S apt-get update
echo $PASSWD | sudo -S dpkg -i $DOCKER_VERSION
echo $PASSWD | sudo -S groupadd docker
echo $PASSWD | sudo -S usermod -aG docker ${DOCKER_USER}

echo $PASSWD | sudo -S mkdir -p /etc/docker
if sudo [ -f "/etc/docker/daemon.json" ]; then
  datetime=$(date +%Y%m%d-%H%M%S)
  echo $PASSWD | sudo -S cp /etc/docker/daemon.json /etc/docker/daemon-$datetime.json
  echo $PASSWD | sudo -S rm -rf /etc/docker/daemon.json
fi

echo $PASSWD | sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF

# 生产环境一定要加graph选项，指定docker镜像和日志的目录为大空间的目录，否则死的时候武眼睇
# echo $PASSWD | sudo tee /etc/docker/daemon.json <<-'EOF'
# {
#    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"],
#    "graph": "/opt/data/docker"
# }
# EOF

echo $PASSWD | sudo -S systemctl restart docker

if sudo [ -f "/usr/local/bin/docker-compose" ]; then
  echo $PASSWD | sudo -S rm -rf /usr/local/bin/docker-compose
fi

echo $PASSWD | sudo -S cp docker-compose-Linux-x86_64-1.16.1 /usr/local/bin/docker-compose
echo $PASSWD | sudo -S chmod +x /usr/local/bin/docker-compose

if sudo [ -f "/usr/local/bin/docker-machine" ]; then
  echo $PASSWD | sudo -S rm -rf /usr/local/bin/docker-machine
fi

echo $PASSWD | sudo -S cp docker-machine-Linux-x86_64-0.13.0 /usr/local/bin/docker-machine
echo $PASSWD | sudo -S chmod +x /usr/local/bin/docker-machine

echo $PASSWD | sudo docker images | head -n 2
echo $PASSWD | docker-compose version
echo $PASSWD | docker-machine version
# 这步是必须的，否则因为 groups 命令获取到的是缓存的组信息，刚添加的组信息未能生效，所以 docker ps -a 执行时有错。或者重启系统让用户组信息生效
newgrp - docker


```
