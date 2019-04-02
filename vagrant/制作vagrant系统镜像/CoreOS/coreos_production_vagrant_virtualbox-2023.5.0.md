### 对官方的CoreOS的vagrant镜像很失望
* 不能指定静态IP，只能dhcp动态分配IP地址  .vm.network :private_network, type: "dhcp"
* 对官方的失望，/etc/ssh/sshd_config文件不能编辑，只能通过coreos-cloudinit -from-file=coreos-sshd-config.yml 命令修改

#### 查考 CoreOS裸机iso安装和相关配置 [https://cloud.tencent.com/developer/article/1335572]
```
# 步骤01 导入vagrant官方的CoreOS虚拟机模板
vagrant box remove -f coreos_production_vagrant_virtualbox-2023.5.0
vagrant box add coreos_production_vagrant_virtualbox-2023.5.0 coreos_production_vagrant_virtualbox-2023.5.0.box

# 步骤02 编写Vagrantfile文件
rm -rf coreos_production_vagrant_virtualbox-2023.5.0 && mkdir -p coreos_production_vagrant_virtualbox-2023.5.0
cd coreos_production_vagrant_virtualbox-2023.5.0

tee Vagrantfile <<-'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :coreos202350 do |coreos202350|
    coreos202350.vm.box = "coreos_production_vagrant_virtualbox-2023.5.0"
    coreos202350.vm.hostname = "coreos202350"
    coreos202350.ssh.insert_key = false
    coreos202350.ssh.forward_agent = true
# 官方的CoreOS的vagrant镜像，ignition.enabled = true 参数是必选的
    coreos202350.ignition.enabled = true
    coreos202350.vm.synced_folder ".", "/vagrant", disabled: true
# 官方的CoreOS的vagrant镜像，IP地址只能是动态的，不能指定静态IP，对官方很失望
    coreos202350.vm.network :private_network, type: "dhcp"
    coreos202350.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--name", "coreos_production_vagrant_virtualbox-2023.5.0", "--memory", "1024", "--cpus", "2" ]
    end
  end
end
EOF

vagrant up

vagrant ssh coreos202350
sudo -i
echo -e "vagrant\nvagrant" | passwd
echo -e "vagrant\nvagrant" | passwd core
cd /etc/ssh
# 对官方的失望，/etc/ssh/sshd_config文件不能编辑，只能通过coreos-cloudinit -from-file=coreos-sshd-config.yml 命令修改
tee coreos-sshd-config.yml <<-'EOF'
#cloud-config
# 第一行必须是 #cloud-config，对官方的失望
write_files:
  - path: /etc/ssh/sshd_config
    permissions: 0600
    owner: root
    content: |
      ClientAliveInterval 180
      UseDNS no
      PermitRootLogin yes
      ChallengeResponseAuthentication no 
      PasswordAuthentication yes
EOF
coreos-cloudinit -from-file=coreos-sshd-config.yml
systemctl enable sshd
systemctl restart sshd
```
