# Ubuntu的vagrant模板的制作

### 注意点
* Ubuntu-16.04版本以上的全新系统，默认root是没有密码的，必须在某个用户的命令行给root设置密码 sudo passwd root  
* Vagrant提供的Ubuntu镜像，vagrant和root用户是不允许远程登录的，修改的/etc/ssh/sshd_config的参数有四个
* Centos的vagrant镜像下载地址 https://cloud-images.ubuntu.com/ , 下载链接https://cloud-images.ubuntu.com/bionic/20181004/bionic-server-cloudimg-amd64-vagrant.box

### 导入vagrant官方的centos7虚拟机模板
```
vagrant box add ubuntu-18.04 bionic-server-cloudimg-amd64-vagrant.box
```

### Vagrantfile文件
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :template do |template|
    template.vm.box = "ubuntu-18.04"
    template.vm.hostname = "template"
    template.ssh.insert_key = false
    template.vm.synced_folder ".", "/vagrant", disabled: true
    template.vm.network :private_network, ip: "192.168.35.11"
    template.vm.provider "virtualbox" do |vb|
      vb.name = "template"
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = "1"
    end
  end
end
```

### 用vagrant ssh登录服务器，修改配置文件允许账号远程登录
```
# 用vagrant ssh登录服务器，修改配置文件允许账号远程登录，修改/etc/ssh/sshd_config
vagrant ssh template
# 给root用户设置密码
sudo passwd root  
# 切换到root用户
su root

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