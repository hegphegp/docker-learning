# vagrant的使用方法

#### 必须先安装virtualbox
#### [vagrant软件下载地址https://releases.hashicorp.com/vagrant](https://releases.hashicorp.com/vagrant)
#### [vagrant镜像下载地址http://cloud.centos.org/centos/7/vagrant/x86_64/images/](http://cloud.centos.org/centos/7/vagrant/x86_64/images/)
#### 建议：直接下载vagrant_2.1.1_x86_64.deb，用 sudo dpkg -i vagrant_2.1.1_x86_64.deb 命令安装，不要下载vagrant_2.1.1_linux_amd64.zip解压放到/usr/bin/目录，亲测解压发到目录，用vagrant命令有问题

### 添加本地仓库的镜像
```
# 在任意目录运行vagrant box add 命令，添加给本来vagrant仓库添加镜像
vagrant box add centos-7.3 /home/hgp/vagrant/CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box
vagrant box add centos-7 /home/hgp/vagrant/CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box
```

### 使用
```
mkdir -p /home/hgp/vagrant/centos
cd /home/hgp/vagrant/centos
vagrant init
# 此时目录下面生成Vagrantfile文件，修改里面的几个参数，例如 config.vm.box 改成本地镜像仓库的镜像名，否则在当前目录查找镜像
# config.vm.network :private_network, ip: "192.168.57.101"
# config.vm.box = "centos-7.3"
# config.vm.boot_timeout = 360
# config.ssh.username = "root"
# config.ssh.password = "root"
# config..gui = true
```

#### 所有官方提供的vagrant镜像都应该有 账号密码 vagrant和vgrant root和vagrant， 默认情况下root和vagrant用户都不允许远程登录的
#### 以CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box为例，启动后修改允许远程登录
```
# 修改PubkeyAuthentication 和 PasswordAuthentication 参数
PubkeyAuthentication yes #这两项为打开公钥模式
PasswordAuthentication yes #打开密码验证模式
# 重启sshd服务
systemctl restart sshd
```

### Vagrantfile 样板
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos-7.3"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "centos-7.3-swarm" #指定虚拟机的名称
    vb.gui = true
    vb.memory = "1024"
    v.cpus = 2
  end
end
```