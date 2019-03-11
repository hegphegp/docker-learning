## Ubuntu sh脚本安装docker,docker-compose,docker-machine

#### 下载离线安装包以及依赖
```
# 添加Docker公共密钥，作用应该是 apt-get 安装 http://mirrors.aliyun.com/docker-ce/linux/ubuntu/ 的docker软件时对比公钥证明仓库是合法的吧
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu//gpg | apt-key add -

cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list
apt-get update
apt-get clean
apt-get autoclean   # 清理旧版本的软件缓存
apt-get clean       # 清理所有软件缓存
apt-get autoremove  # 删除系统不再使用的孤立软件

# 列表显示版本库中可以安装的Docker CE
apt-cache madison docker-ce
# docker-ce | 5:18.09.3~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:18.09.2~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:18.09.1~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:18.09.0~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.3~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.2~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.1~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.0~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.03.1~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages

cd /var/cache/apt/archives
rm -rf *.deb
apt-get install -y -d docker-ce=5:18.09.3~3-0~ubuntu-bionic
mkdir -p /root/hgp/docker-ce/18.09
cp -r /var/cache/apt/archives/* /root/hgp/docker-ce/18.09/
rm -rf /root/hgp/docker-ce/18.09/lock
rm -rf /root/hgp/docker-ce/18.09/partial
```

#### 下载软件安装包及其依赖( apt-get -d install 软件名=版本号 )，对这条命令很绝望，居然不能下载到指定目录，直接下载到/var/cache/apt/archives目录。白白浪费了半天生命各种百度，痛恨一切垃圾命令、工具和设计
```
# 列表显示版本库中可以安装的Docker CE
apt-cache madison docker-ce
# docker-ce | 5:18.09.3~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:18.09.2~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:18.09.1~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:18.09.0~3-0~ubuntu-bionic | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.3~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.2~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.1~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.06.0~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 18.03.1~ce~3-0~ubuntu | http://mirrors.aliyun.com/docker-ce/linux/ubuntu bionic/stable amd64 Packages

# apt-get install -y -d docker-ce=18.06.3~ce~3-0~ubuntu
# apt-get install -d docker-ce=5:18.09.2~3-0~ubuntu-bionic
# apt-get install -d docker-ce=5:18.09.1~3-0~ubuntu-bionic
# apt-get install -d docker-ce=5:18.09.0~3-0~ubuntu-bionic
# apt-get install -d docker-ce=18.06.3~ce~3-0~ubuntu
# apt-get install -d docker-ce=18.06.2~ce~3-0~ubuntu
# apt-get install -d docker-ce=18.06.1~ce~3-0~ubuntu
# apt-get install -d docker-ce=18.06.0~ce~3-0~ubuntu
# apt-get install -d docker-ce=18.03.1~ce~3-0~ubuntu
cd /var/cache/apt/archives
rm -rf *.deb
apt-get install -d docker-ce=5:18.09.3~3-0~ubuntu-bionic
mkdir -p /root/hgp/docker-ce/18.09
cp -r /var/cache/apt/archives/* /root/hgp/docker-ce/18.09/
rm -rf /root/hgp/docker-ce/18.09/lock /root/hgp/docker-ce/18.09/partial
cd /root/hgp/docker-ce/18.09
# dpkg -i *.deb
```


[16.04-Xenial的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/xenial/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/xenial/pool/edge/amd64/)  
[16.10-Yakkety的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/yakkety/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/yakkety/pool/edge/amd64/)  
[17.04-Zesty的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/zesty/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/zesty/pool/edge/amd64/)  
[17.10-Artful的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/artful/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/artful/pool/edge/amd64/)  
[18.04-Bionic的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/edge/amd64/](https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/edge/amd64/)  
[docker-compose的官方下载地址https://github.com/docker/compose/releases/](https://github.com/docker/compose/releases/)  
[docker-compose的阿里云下载地址https://mirrors.aliyun.com/docker-toolbox/linux/compose/](https://mirrors.aliyun.com/docker-toolbox/linux/compose/)  
[docker-machine的官方下载地址https://github.com/docker/machine/releases/](https://github.com/docker/machine/releases)  
[docker-machine的阿里云下载地址https://mirrors.aliyun.com/docker-toolbox/linux/machine/](https://mirrors.aliyun.com/docker-toolbox/linux/machine/)  

### Ubuntu18.04安装docker-ce_18.09.0~3-0~ubuntu-bionic_amd64.deb
```
# 用root用户安装
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list
apt-get update
apt-get clean
apt-get autoclean   # 清理旧版本的软件缓存
apt-get clean       # 清理所有软件缓存
apt-get autoremove  # 删除系统不再使用的孤立软件

curl https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_1.2.0-1_amd64.deb > containerd.io_1.2.0-1_amd64.deb 
curl https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_18.09.0~3-0~ubuntu-bionic_amd64.deb > docker-ce_18.09.0~3-0~ubuntu-bionic_amd64.deb
curl https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_18.09.0~3-0~ubuntu-bionic_amd64.deb > docker-ce-cli_18.09.0~3-0~ubuntu-bionic_amd64.deb
sudo dpkg -i containerd.io_1.2.0-1_amd64.deb
sudo dpkg -i docker-ce-cli_18.09.0~3-0~ubuntu-bionic_amd64.deb
sudo dpkg -i docker-ce_18.09.0~3-0~ubuntu-bionic_amd64.deb

# groupadd docker
# usermod -aG docker hgp
# 这步是必须的，否则因为 groups 命令获取到的是缓存的组信息，刚添加的组信息未能生效，所以 docker ps -a 执行时有错。或者重启系统让用户组信息生效
# newgrp - docker
```