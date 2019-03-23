
## 都切换到root用户进行命令操作

### 配置阿里云加速器
```
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update && apt-get clean && apt-get autoclean && apt-get clean && apt-get autoremove
```

### 安装ssh
```
# 查看是否已经安装ssh
ps -e | grep ssh
apt-get install -y openssh-server

# 配置sshd参数
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep UseDNS
cat /etc/ssh/sshd_config | grep GSSAPIAuthentication
cat /etc/ssh/sshd_config | grep PermitRootLogin
sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config ;
sed -ri 's/^PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config ;
sed -ri 's/^GSSAPIAuthentication\s+.*/GSSAPIAuthentication no/' /etc/ssh/sshd_config ;
sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config ;
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep GSSAPIAuthentication
cat /etc/ssh/sshd_config | grep PermitRootLogin
systemctl restart sshd
```

### 安装docker
```
# 用root用户安装
mkdir -p /etc/apt/sources.list.d
echo "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/aliyun-docker.list

# 添加Docker公共密钥，作用应该是 apt-get 安装 http://mirrors.aliyun.com/docker-ce/linux/ubuntu/ 的docker软件时对比公钥证明仓库是合法的吧
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu//gpg | apt-key add -

apt-get update && apt-get clean && apt-get autoclean && apt-get clean && apt-get autoremove

apt-get install -y docker-ce

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
systemctl restart docker

# 安装docker-compose
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# groupadd docker
# usermod -aG docker hgp
# 这步是必须的，否则因为 groups 命令获取到的是缓存的组信息，刚添加的组信息未能生效，所以 docker ps -a 执行时有错。或者重启系统让用户组信息生效
# newgrp - docker

```

### 上官网下载VSCode的deb安装包安装
```
```

### 安装最新的chrome浏览器
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

### 安装搜狗输入法
```
# 去官网下载搜狗输入法  sogoupinyin_2.2.0.0108_amd64.deb
# wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb
sudo dpkg -i sogoupinyin_2.2.0.0108_amd64.deb
sudo apt-get install -f          # 自动修复包的依赖
# sudo apt --fix-broken install  # 自动修复包的依赖
sudo dpkg -i sogoupinyin_2.2.0.0108_amd64.deb
# 配置输入法 Setting -> Region & Language -> Manage Installed Languages 把Keboard input method system从IBus修改为fcitx
# 然后直接重启系统
```


### 安装virtualbox
* 必须安装Linux内核头文件依赖，virtualbox用到Linux内核头文件，否则无法创建网卡或者其他一大堆错误
```
# 查看内核版本 uname -r
# 4.18.0-16-generic
apt-get install build-essential linux-headers-`uname -r`
mkdir -p /etc/apt/sources.list.d
sudo echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" > /etc/apt/sources.list.d/virtualbox.list
# 添加 Oracle virtualbox 公钥
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
apt-get update
apt-get install -y virtualbox-5.2
# 设置 virtualbox 内核模块开机启动
systemctl enable vboxdrv
systemctl restart vboxdrv
# sudo usermod -aG vboxusers 用户名
```

### 安装vagrant
```
# 网上的人说 sudo apt-get install vagrant -y 不支持VirtualBox 5.2版，所以要去官网手动下载安装vagrant二进制包
# 官网下载页 https://www.vagrantup.com/downloads.html
# 安装2.2.4版本
wget https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb
dpkg -i vagrant_2.2.4_x86_64.deb
apt-get install -f          # 自动修复包的依赖
dpkg -i vagrant_2.2.4_x86_64.deb
```

### 截图工具
```

apt-get install -y shutter
```