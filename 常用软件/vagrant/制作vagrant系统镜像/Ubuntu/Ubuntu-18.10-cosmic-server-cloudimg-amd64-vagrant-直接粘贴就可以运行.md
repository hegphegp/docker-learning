#### 前提：在命令运行的目录路径下准备好 Ubuntu-18.10-cosmic-server-cloudimg-amd64-vagrant.box
```
# 步骤01 导入vagrant官方的ubuntu-1810虚拟机模板
vagrant box remove -f Ubuntu-18.10-cosmic-server-cloudimg-amd64
vagrant box add Ubuntu-18.10-cosmic-server-cloudimg-amd64 Ubuntu-18.10-cosmic-server-cloudimg-amd64-vagrant.box

# 步骤02 编写Vagrantfile文件
rm -rf Ubuntu-18.10-cosmic-server-cloudimg-amd64
mkdir -p Ubuntu-18.10-cosmic-server-cloudimg-amd64
cd Ubuntu-18.10-cosmic-server-cloudimg-amd64

tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :ubuntu1810 do |ubuntu1810|
    ubuntu1810.vm.box = "Ubuntu-18.10-cosmic-server-cloudimg-amd64"
    ubuntu1810.vm.hostname = "ubuntu-1810"
# 官方镜像都不能设置账号密码登录，因为官方原始镜像的/etc/ssh/sshd_config文件配置都是不允许任何账号远程登录的
    ubuntu1810.vm.synced_folder ".", "/vagrant", disabled: true
    ubuntu1810.vm.network :private_network, ip: "192.168.35.11"
    ubuntu1810.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--name", "Ubuntu-18.10-cosmic-server-cloudimg-amd64", "--memory", "1024", "--cpus", "2", "--uartmode1", "disconnected" ]
    end
  end
end
EOF

vagrant up

# 步骤03 用vagrant ssh登录服务器，修改配置文件 /etc/ssh/sshd_config 允许账号远程登录
vagrant ssh ubuntu1810
# sudo -i 命令 是让当前操作的所有命令拥有超级管理员的权限
sudo -i
# echo -e "vagrant\nvagrant" | passwd             # 修改自己的密码
# echo -e "vagrant\nvagrant" | passwd 指定用户名    # 修改指定用户名的密码
echo -e "vagrant\nvagrant" | passwd
sed -ri 's|^#?PubkeyAuthentication\s+.*|PubkeyAuthentication yes|' /etc/ssh/sshd_config ;
sed -ri 's|^PasswordAuthentication\s+.*|PasswordAuthentication yes|' /etc/ssh/sshd_config ;
sed -ri 's|^GSSAPIAuthentication\s+.*|GSSAPIAuthentication no|' /etc/ssh/sshd_config ;
sed -ri 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config ;
systemctl restart sshd

# 步骤04 修改的apt源
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
systemctl disable apt-daily.service
systemctl disable apt-daily.timer

# 步骤05 安装docker
apt-get update
apt-get -y install apt-transport-https ca-certificates curl software-properties-common

#######################  停止copy  #############################

# 安装GPG证书
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
# 写入软件源信息
add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# 更新并安装Docker-CE
apt-get -y update
apt-get -y install docker-ce

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kfp63jaj.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
systemctl restart docker

# 安装docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
# ALL_PROXY=socks5://127.0.0.1:1080 curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

cd /var/cache/apt/archives
rm -rf *.deb

shutdown -h now

# 步骤06 在宿主机导出虚拟机
vagrant package --base=Ubuntu-18.10-cosmic-server-cloudimg-amd64 --output=Ubuntu-18.10-cosmic-server-cloudimg-amd64-vagrant.box
vagrant box remove -f ubuntu-1810-template
vagrant box remove -f Ubuntu-18.10-cosmic-server-cloudimg-amd64
vagrant box add ubuntu-1810-template Ubuntu-18.10-cosmic-server-cloudimg-amd64-vagrant.box

# 步骤07 删除virtualbox的ubuntu-1804虚拟机
vagrant destroy -f ubuntu1810
cd ..
rm -rf Ubuntu-18.10-cosmic-server-cloudimg-amd64


```
