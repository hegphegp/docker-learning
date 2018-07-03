# 虚拟机vagrant模板的制作

* *账号密码 vagrant:vagrant和root:vagrant*
* *docker的下载页面 https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/ ,下载的链接 https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm*
* *vagrant的下载页面 http://cloud.centos.org/centos/7/vagrant/x86_64/images/ ,下载的链接 http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box*
* *用vagrant ssh登录服务器，修改配置文件允许账号远程登录*
* *换成阿里的yum源*
* *安装docker，并指定加速仓库*
* *导出虚拟机前先清空网络配置*
* *用vagrant package 导出虚拟机*
  
  
  
### 导入vagrant官方的centos7虚拟机模板
```
vagrant box add centos-7.3 CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box
```

### 编写Vagrant
```
rm -rf docker-templates
mkdir -p docker-templates
cd docker-templates

# 编写Vagrantfile文件
# =========================================================================================
tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :template do |template|
    template.vm.box = "centos-7.3"
    template.vm.hostname = "template"
    template.vm.synced_folder ".", "/vagrant", disabled: true
    template.vm.network :private_network, ip: "192.168.35.11"
    template.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "template", "--memory", "1024", "--cpus", "1" ]
    end
  end
end
EOF
# =========================================================================================

vagrant up
```

### 用vagrant ssh登录服务器，修改配置文件允许账号远程登录
```
# 用vagrant ssh登录服务器，修改配置文件允许账号远程登录，修改/etc/ssh/sshd_config
vagrant ssh template
# 切换到root用户
su root

# PubkeyAuthentication yes    # 打开公钥验证模式
# PasswordAuthentication yes  # 打开密码验证模式
# UseDNS no                   # 修改UseDNS为no，该镜像的UseDNS原来就是no，不用改
# GSSAPIAuthentication no     # 修改GSSAPIAuthentication为no
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep UseDNS
cat /etc/ssh/sshd_config | grep GSSAPIAuthentication
sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config ;
sed -ri 's/^PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config ;
sed -ri 's/^GSSAPIAuthentication\s+.*/GSSAPIAuthentication no/' /etc/ssh/sshd_config ;
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep GSSAPIAuthentication
systemctl restart sshd
```

### 修改的yum源
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
echo "export LC_ALL=en_US.UTF-8"  >>  /etc/profile
source /etc/profile
yum clean all
yum makecache
yum clean all
```

### 安装docker和docker-compose，并指定加速仓库
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
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum clean all
rm -rf /var/cache/yum
```

### 导出虚拟机前先清空网络配置
```
# 网上说，要删除 /etc/udev/rules.d/70-persistent-net.rules ，用官方的CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box创建虚拟机，/etc/udev/rules.d目录下面没有任何文件
# 用yum安装了docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm，发现/etc/udev/rules.d目录下面多出了 80-docker.rules 文件
# rm -rf /etc/udev/rules.d/70-persistent-net.rules

# 用官方的CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box创建虚拟机后，/etc/sysconfig/network-scripts/ifcfg-eth0网卡没有写定什么参数，/etc/sysconfig/network-scripts/ifcfg-eth1网卡配置了IP，应该删掉
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
rm -rf /etc/sysconfig/network-scripts/ifcfg-eth1
shutdown -h now
```

### 在宿主机导出虚拟机
```
vagrant package --base=template --output=centos7-1805-docker.VirtualBox.box
vagrant box add centos7-1805-docker centos7-1805-docker.VirtualBox.box
```

### Vagrantfile文件
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :template do |template|
    template.vm.box = "centos-7.3"
    template.vm.hostname = "template"
    template.vm.synced_folder ".", "/vagrant", disabled: true
    template.vm.network :private_network, ip: "192.168.35.11"
    template.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "template", "--memory", "1024", "--cpus", "1" ]
    end
  end
end
```