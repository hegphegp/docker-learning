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