```
# 步骤01 导入vagrant官方的 kali-linux-2020.4.0-vagrant 虚拟机模板
vagrant box remove -f kali-linux-2020.4.0
vagrant box add kali-linux-2020.4.0 kali-linux-2020.4.0-vagrant.box

# 步骤02 编写Vagrantfile文件
rm -rf kali-linux-2020.4.0
mkdir -p kali-linux-2020.4.0
cd kali-linux-2020.4.0

tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :kaliLinux2040 do |kaliLinux2040|
    kaliLinux2040.vm.box = "kali-linux-2020.4.0"
    kaliLinux2040.vm.hostname = "kaliLinux-2040"
    kaliLinux2040.ssh.username = "vagrant"
    kaliLinux2040.ssh.password = "vagrant"
    kaliLinux2040.ssh.insert_key = false
    kaliLinux2040.vm.synced_folder ".", "/vagrant", disabled: true
    kaliLinux2040.vm.network :private_network, ip: "192.168.35.11"
    kaliLinux2040.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--name", "kaliLinux-2040", "--memory", "8192", "--cpus", "6" ]
    end
  end
end
EOF

vagrant up

```
