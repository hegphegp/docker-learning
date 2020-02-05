### 使用账号密码登录
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :manager1 do |manager1|
    manager1.vm.box = "centos7-1805-docker"
    manager1.vm.hostname = "manager1"
    manager1.vm.synced_folder ".", "/vagrant", disabled: true
    manager1.vm.network :private_network, ip: "192.168.35.11"
    manager1.ssh.username = "vagrant"
    manager1.ssh.password = "vagrant"
    manager1.ssh.insert_key = false
#   config.vm.network "public_network", ip: "192.168.66.32", bridge: "en0: Wi-Fi (Airport)", bootproto: "static", gateway: "192.168.66.1", dns: "114.114.114.114"
    manager1.vm.provider "virtualbox" do |v|
#       查看所有参数  VBoxManage modifyvm --help
      v.customize [ "modifyvm", :id, "--name", "manager1", "--memory", "1024", "--cpus", "1" ]
    end
  end


  config.vm.define :manager2 do |manager2|
    manager2.vm.box = "centos7-1805-docker"
    manager2.vm.hostname = "manager2"
    manager2.vm.synced_folder ".", "/vagrant", disabled: true
    manager2.vm.network :private_network, ip: "192.168.35.12"
    manager2.ssh.username = "vagrant"
    manager2.ssh.password = "vagrant"
    manager2.ssh.insert_key = false
    manager2.vm.provider "virtualbox" do |v|
      v.name = "manager2"
      v.gui = false
      v.memory = "1024"
      v.cpus = "1"
    end
  end


  config.vm.define :manager3 do |manager3|
    manager3.vm.box = "centos7-1805-docker"
    manager3.vm.hostname = "manager3"
    manager3.vm.synced_folder ".", "/vagrant", disabled: true
    manager3.vm.network :private_network, ip: "192.168.35.13"
    manager3.ssh.username = "vagrant"
    manager3.ssh.password = "vagrant"
    manager3.ssh.insert_key = false
    manager3.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "manager3", "--memory", "1024", "--cpus", "1" ]
    end
  end


  config.vm.define :worker1 do |worker1|
    worker1.vm.box = "centos7-1805-docker"
    worker1.vm.hostname = "worker1"
    worker1.vm.synced_folder ".", "/vagrant", disabled: true
    worker1.vm.network :private_network, ip: "192.168.35.14"
    worker1.ssh.username = "vagrant"
    worker1.ssh.password = "vagrant"
    worker1.ssh.insert_key = false
    worker1.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "worker1", "--memory", "1024", "--cpus", "1" ]
    end
  end


  config.vm.define :worker2 do |worker2|
    worker2.vm.box = "centos7-1805-docker"
    worker2.vm.hostname = "worker2"
    worker2.vm.synced_folder ".", "/vagrant", disabled: true
    worker2.vm.network :private_network, ip: "192.168.35.15"
    worker2.ssh.username = "vagrant"
    worker2.ssh.password = "vagrant"
    worker2.ssh.insert_key = false
    worker2.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "worker2", "--memory", "1024", "--cpus", "1" ]
    end
  end


  config.vm.define :worker3 do |worker3|
    worker3.vm.box = "centos7-1805-docker"
    worker3.vm.hostname = "worker3"
    worker3.vm.synced_folder ".", "/vagrant", disabled: true
    worker3.vm.network :private_network, ip: "192.168.35.16"
    worker3.ssh.username = "vagrant"
    worker3.ssh.password = "vagrant"
    worker3.ssh.insert_key = false
    worker3.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "worker3", "--memory", "1024", "--cpus", "1" ]
    end
  end

end
```

### 使用sshkey免密登录
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 建立多台VM，並且他们能够互相通信，假设一台是应用服务器、一台是redis服务器，只需要通过config.vm.define来定义不同的角色就可以了，配置文件进行如下设置：
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
```