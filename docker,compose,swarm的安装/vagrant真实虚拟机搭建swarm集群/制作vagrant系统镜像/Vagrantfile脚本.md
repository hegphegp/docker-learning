# Vagrantfile脚本

```
rm -rf .vagrant
rm -rf Vagrantfile

# 编写Vagrantfile文件
# =========================================================================================
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :web do |web|
    web.vm.box = "centos-7.3"
    web.vm.hostname = "web"
    web.vm.synced_folder ".", "/vagrant", disabled: true
# vagrant发神经病的两个参数template.ssh.username和template.ssh.password
# 绝世大坑，Vagrantfile文件不能配置template.ssh.username和template.ssh.password，配置的账号密码即使是正确的也不行
# 配了上面两个参数，vagrant就会发神经病，不停地用配置的账号密码尝试登录，正确账号密码不停尝试都登录不了
#    template.ssh.username = "vagrant"
#    template.ssh.password = "vagrant"
    web.vm.network :private_network, ip: "192.168.33.10"
    web.vm.provider "virtualbox" do |v|
#       查看所有参数  VBoxManage modifyvm --help
#       v.name   = "web"
#       v.memory = "1024"
#       v.cpus   = "2"
      v.customize [ "modifyvm", :id, "--name", "web", "--memory", "1024", "--cpus", "2" ]
    end
  end

  config.vm.define :redis do |redis|
    redis.vm.box = "centos-7.3"
    redis.vm.hostname = "redis"
    redis.vm.synced_folder ".", "/vagrant", disabled: true
    redis.vm.network :private_network, ip: "192.168.33.11"
# vagrant发神经病的两个参数template.ssh.username和template.ssh.password
# 绝世大坑，Vagrantfile文件不能配置template.ssh.username和template.ssh.password，配置的账号密码即使是正确的也不行
# 配了上面两个参数，vagrant就会发神经病，不停地用配置的账号密码尝试登录，正确账号密码不停尝试都登录不了
#    template.ssh.username = "vagrant"
#    template.ssh.password = "vagrant"
    redis.vm.provider "virtualbox" do |v|
#       查看所有参数  VBoxManage modifyvm --help
#       v.name   = "redis"
#       v.memory = "1024"
#       v.cpus   = "2"
      v.customize [ "modifyvm", :id, "--name", "redis", "--memory", "1024", "--cpus", "2" ]
    end
  end
end
EOF
# =========================================================================================
```