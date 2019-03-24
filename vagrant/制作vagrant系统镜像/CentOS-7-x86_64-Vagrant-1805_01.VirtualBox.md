```
# 步骤01 导入vagrant官方的centos7虚拟机模板
vagrant box remove -f CentOS-7-x86_64-Vagrant-1805_01
vagrant box add CentOS-7-x86_64-Vagrant-1805_01 CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box

# 步骤02 编写Vagrantfile文件
rm -rf CentOS-7-x86_64-Vagrant-1805_01
mkdir -p CentOS-7-x86_64-Vagrant-1805_01
cd CentOS-7-x86_64-Vagrant-1805_01

tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :centos1805 do |centos1805|
    centos1805.vm.box = "CentOS-7-x86_64-Vagrant-1805_01"
    centos1805.vm.hostname = "CentOS-1805"
# 官方镜像都不能设置账号密码登录，因为官方原始镜像的/etc/ssh/sshd_config文件配置都是不允许任何账号远程登录的
    centos1805.vm.synced_folder ".", "/vagrant", disabled: true
    centos1805.vm.network :private_network, ip: "192.168.130.11"
    centos1805.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--name", "CentOS-7-x86_64-Vagrant-1805_01", "--memory", "1024", "--cpus", "2" ]
    end
  end
end
EOF

vagrant up

# 步骤03 用vagrant ssh登录服务器，修改配置文件 /etc/ssh/sshd_config 允许账号远程登录
vagrant ssh centos1805
echo "vagrant" | sudo -S sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config ;
echo "vagrant" | sudo -S sed -ri 's/^PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config ;
echo "vagrant" | sudo -S sed -ri 's/^GSSAPIAuthentication\s+.*/GSSAPIAuthentication no/' /etc/ssh/sshd_config ;
echo "vagrant" | sudo -S systemctl restart sshd

# 步骤04 修改的yum源
echo "vagrant" | sudo -S mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
echo "vagrant" | sudo -S curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
echo "vagrant" | sudo -S echo "export LC_ALL=en_US.UTF-8"  >>  /etc/profile
echo "vagrant" | sudo -S source /etc/profile
echo "vagrant" | sudo -S yum clean all
echo "vagrant" | sudo -S yum makecache
echo "vagrant" | sudo -S yum clean all

# 步骤05 清空网络配置，然后作为模板
# 网上说，要删除 /etc/udev/rules.d/70-persistent-net.rules ，用官方的CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box创建虚拟机，/etc/udev/rules.d目录下面没有任何文件
# 用官方的CentOS-7-x86_64-Vagrant-1805_01.VirtualBox.box创建虚拟机后，/etc/sysconfig/network-scripts/ifcfg-eth0网卡没有写定什么参数，/etc/sysconfig/network-scripts/ifcfg-eth1网卡配置了IP，应该删掉
echo "vagrant" | sudo -S sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo "vagrant" | sudo -S sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo "vagrant" | sudo -S rm -rf /etc/sysconfig/network-scripts/ifcfg-eth1
echo "vagrant" | sudo -S shutdown -h now

# 步骤06 在宿主机导出虚拟机
rm -rf CentOS-1805-vagrant-templates.VirtualBox.box
vagrant package --base=CentOS-7-x86_64-Vagrant-1805_01 --output=CentOS-1805-vagrant-templates.VirtualBox.box
vagrant box remove -f CentOS-1805-template
vagrant box remove -f CentOS-7-x86_64-Vagrant-1805_01
vagrant box add CentOS-1805-template CentOS-1805-vagrant-templates.VirtualBox.box

# 步骤07 删除virtualbox的CentOS-1805虚拟机
vagrant destroy -f centos1805
cd ..
rm -rf CentOS-7-x86_64-Vagrant-1805_01

```
