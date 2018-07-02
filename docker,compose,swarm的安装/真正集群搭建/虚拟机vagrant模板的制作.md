# 虚拟机vagrant模板的制作

* 账号密码 vagrant:vagrant和root:vagrant
* docker的下载页面 https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/ ,下载的链接 https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
* vagrant的下载页面 http://cloud.centos.org/centos/7/vagrant/x86_64/images/ ,下载的链接 http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box
* 允许账号远程登录
* 换成阿里的yum源
* 安装docker，并指定加速仓库
* 用vagrant package 导出虚拟机

##### 导入vagrant官方的centos7虚拟机模板
```
vagrant box add centos-7.3 CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box
```

##### 导入vagrant官方的centos7虚拟机模板
```
rm -rf .vagrant
rm -rf Vagrantfile

# 编写Vagrantfile文件
# =========================================================================================
tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = "centos-7.3"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "centos-7.3"
    vb.gui = true
    vb.memory = "1024"
    vb.cpus = "2"
  end
end
EOF
# =========================================================================================
```

##### 启动虚拟机并修改允许远程登录
```
vagrant up

# 去到虚拟机中修改账号允许远程登录，修改/etc/ssh/sshd_config
# PubkeyAuthentication yes   #打开公钥验证模式
# PasswordAuthentication yes #打开密码验证模式
systemctl restart sshd
```

##### 远程登录修改的yum源
```
ssh root@192.168.33.10

yum install -y wget
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache
yum clean all
rm -rf /var/cache/yum
```

##### 安装docker，并指定加速仓库
```
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm  #安装docker

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://1a5q7qx0.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
sudo systemctl restart docker
rm -rf /var/cache/yum
shutdown -h now
```

##### 在宿主机导出虚拟机
```
vagrant package --base=centos-7.3 --output=centos7-1805-docker.VirtualBox.box
vagrant box add centos7-1805-docker centos7-1805-docker.VirtualBox.box
```

#### Vagrantfile文件
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = "centos-7.3"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "centos-7.3"
    vb.gui = true
    vb.memory = "1024"
    vb.cpus = "2"
  end
end
```