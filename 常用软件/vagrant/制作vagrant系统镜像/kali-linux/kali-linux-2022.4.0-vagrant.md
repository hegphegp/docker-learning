```
# 步骤01 导入vagrant官方的 kali-linux-2022.4.0-vagrant 虚拟机模板
vagrant box remove -f kali-linux-2022.4.0
vagrant box add kali-linux-2022.4.0 kali-linux-2022.4.0-vagrant.box

# 步骤02 编写Vagrantfile文件
rm -rf kali-linux-2022.4.0
mkdir -p kali-linux-2022.4.0
cd kali-linux-2022.4.0

tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :kaliLinux2240 do |kaliLinux2240|
    kaliLinux2240.vm.box = "kali-linux-2022.4.0"
    kaliLinux2240.vm.hostname = "kaliLinux-2240"
    kaliLinux2240.ssh.username = "vagrant"
    kaliLinux2240.ssh.password = "vagrant"
    kaliLinux2240.ssh.insert_key = false
    kaliLinux2240.vm.synced_folder ".", "/vagrant", disabled: true
    kaliLinux2240.vm.network :private_network, ip: "192.168.35.11"
    kaliLinux2240.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--name", "kaliLinux-2240", "--memory", "8192", "--cpus", "6" ]
    end
  end
end
EOF

vagrant up

```
