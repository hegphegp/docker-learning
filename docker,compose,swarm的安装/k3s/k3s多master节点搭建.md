### k3s多master节点搭建
* 谨记，环境变量不能出现 K3S_URL 环境变量，否则当前节点就会变成agent节点，就GG了
* 谨记，vagrant官方创建的虚拟机，eth0会被10.0.2.15这个IP占用，k3s的服务必须指定网卡，否则默认用了eth0网卡，容器之前无法通讯

##### 环境搭建，先用vagrant创建三台服务器，然后每个节点的/root/k3s/all-rpms准备好所有rpm安装包（找台全新的虚拟机，使用yum下载离线安装包），/root/k3s目录准备好k3s安装文件
* 三台虚拟机的IP地址是
```
192.168.35.11   k3s-master1
192.168.35.12   k3s-master2
192.168.35.13   k3s-master3
```

##### Vagrantfile脚本
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :master1 do |master1|
    master1.vm.box = "centos-1907-template"
    master1.vm.hostname = "k3s-master1"
    master1.vm.synced_folder ".", "/vagrant", disabled: true
    master1.vm.network :private_network, ip: "192.168.35.11"
    master1.ssh.username = "root"
    master1.ssh.password = "vagrant"
    master1.ssh.insert_key = false
    master1.vm.provider "virtualbox" do |v|
#       查看所有参数  VBoxManage modifyvm --help
      v.customize [ "modifyvm", :id, "--name", "k3s-master1", "--memory", "2048", "--cpus", "2" ]
    end
  end


  config.vm.define :master2 do |master2|
    master2.vm.box = "centos-1907-template"
    master2.vm.hostname = "k3s-master2"
    master2.vm.synced_folder ".", "/vagrant", disabled: true
    master2.vm.network :private_network, ip: "192.168.35.12"
    master2.ssh.username = "root"
    master2.ssh.password = "vagrant"
    master2.ssh.insert_key = false
    master2.vm.provider "virtualbox" do |v|
      v.name = "k3s-master2"
      v.gui = false
      v.memory = "2048"
      v.cpus = "2"
    end
  end


  config.vm.define :master3 do |master3|
    master3.vm.box = "centos-1907-template"
    master3.vm.hostname = "k3s-master3"
    master3.vm.synced_folder ".", "/vagrant", disabled: true
    master3.vm.network :private_network, ip: "192.168.35.13"
    master3.ssh.username = "root"
    master3.ssh.password = "vagrant"
    master3.ssh.insert_key = false
    master3.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "k3s-master3", "--memory", "2048", "--cpus", "2" ]
    end
  end


  config.vm.define :worker1 do |worker1|
    worker1.vm.box = "centos-1907-template"
    worker1.vm.hostname = "k3s-worker1"
    worker1.vm.synced_folder ".", "/vagrant", disabled: true
    worker1.vm.network :private_network, ip: "192.168.35.14"
    worker1.ssh.username = "root"
    worker1.ssh.password = "vagrant"
    worker1.ssh.insert_key = false
    worker1.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "k3s-worker1", "--memory", "1024", "--cpus", "1" ]
    end
  end


  config.vm.define :worker2 do |worker2|
    worker2.vm.box = "centos-1907-template"
    worker2.vm.hostname = "k3s-worker2"
    worker2.vm.synced_folder ".", "/vagrant", disabled: true
    worker2.vm.network :private_network, ip: "192.168.35.15"
    worker2.ssh.username = "root"
    worker2.ssh.password = "vagrant"
    worker2.ssh.insert_key = false
    worker2.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "k3s-worker2", "--memory", "1024", "--cpus", "1" ]
    end
  end


  config.vm.define :worker3 do |worker3|
    worker3.vm.box = "centos-1907-template"
    worker3.vm.hostname = "k3s-worker3"
    worker3.vm.synced_folder ".", "/vagrant", disabled: true
    worker3.vm.network :private_network, ip: "192.168.35.16"
    worker3.ssh.username = "root"
    worker3.ssh.password = "vagrant"
    worker3.ssh.insert_key = false
    worker3.vm.provider "virtualbox" do |v|
      v.customize [ "modifyvm", :id, "--name", "k3s-worker3", "--memory", "1024", "--cpus", "1" ]
    end
  end

end

```


##### 下载离线安装包
```
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i "/mirrors.cloud.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum clean all && yum makecache
yum list docker-ce --showduplicates | sort -r
mkdir -p /root/k3s/all-rpms
yum install --downloadonly --downloaddir=/root/k3s/all-rpms docker-ce-19.03.12
rpm -i https://rpm.rancher.io/k3s-selinux-0.1.1-rc1.el7.noarch.rpm
yum install --downloadonly --downloaddir=/root/k3s/all-rpms container-selinux selinux-policy-base
curl https://docs.rancher.cn/k3s/k3s-install.sh > /root/k3s/install.sh

# k3s二进制文件 和 k3s的docker依赖镜像手动到github的仓库下载
```

[install.sh安装脚本的下载地址 https://docs.rancher.cn/k3s/k3s-install.sh](https://docs.rancher.cn/k3s/k3s-install.sh)  
[k3s二进制文件的下载地址 https://github.com/rancher/k3s/releases](https://github.com/rancher/k3s/releases)  
[k3s依赖镜像的下载地址 https://github.com/rancher/k3s/releases](https://github.com/rancher/k3s/releases)  

#### master1节点搭建
* 基础软件环境安装
```
sed -i '/k3s-master1/d' /etc/hosts
sed -i '/k3s-master2/d' /etc/hosts
sed -i '/k3s-master3/d' /etc/hosts

echo "192.168.35.11 k3s-master1" >> /etc/hosts
echo "192.168.35.12 k3s-master2" >> /etc/hosts
echo "192.168.35.13 k3s-master3" >> /etc/hosts

systemctl stop firewalld
systemctl disable firewalld

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

cd /root/k3s/all-rpms
yum install -y *.rpm
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kfp63jaj.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
sudo systemctl restart docker

cd /root/k3s/
docker load < k3s-airgap-images-amd64.tar

reboot

```

* 安装k3s
```
cd /root/k3s/
chmod a+x install.sh k3s
\cp ./k3s /usr/local/bin
export INSTALL_K3S_BIN_DIR=/usr/local/bin
export INSTALL_K3S_SKIP_DOWNLOAD=true
# 手动指定token
# /var/lib/rancher/k3s/server/cred/passwd
# /var/lib/rancher/k3s/server/cred/passwd
# /var/lib/rancher/k3s/server/token
# 上面三个文件有保存K3S_TOKEN的内容
export INSTALL_K3S_TOKEN=3E1AEADCA9BCA0E6523B8766753E9C44
export K3S_TOKEN=3E1AEADCA9BCA0E6523B8766753E9C44
export INSTALL_K3S_EXEC="--docker --cluster-init --no-deploy traefik --bind-address=192.168.35.11 --node-ip=192.168.35.11 --cluster-cidr=10.128.0.0/16 --service-cidr=10.129.0.0/16 --write-kubeconfig=/root/.kube/config --write-kubeconfig-mode=644 --flannel-iface='eth1'"
bash install.sh

# --docker: k3s server组件以containerd作为容器运行时。可以顺便在k3s server节点上启动一个agent节点，agent节点可以使用docker作为容器运行时，这样k3s server节点也可以当做工作节点用。当然也可以不在server节点上启动agent节点（添加参数–disable-agent即可）。
# --bind-address：k3s监听的IP地址，非必选，默认是localhost。
# --cluster-cidr：与kubernetes一样，也就是pod所在网络平面，非必选，默认是10.42.0.0/16.
# --service-cidr：与kubernetes一样，服务所在的网络平面，非必选，默认是10.43.0.0/16.
# --kube-apiserver-arg：额外的api server配置参数，具体可以参考kuberntes官方网站了解支持的配置选项，非必选。
# --write-kubeconfig：安装时顺便写一个kubeconfig文件，方便使用kubectl工具直接访问。如果不加此参数，则默认的配置文件路径为/etc/rancher/k3s/k3s.yaml，默认只有root用户能读。
# --write-kubeconfig-mode：与–write-kubeconfig一起使用，指定kubeconfig文件的权限。
# --node-label：顺便给节点打上一个asrole=worker的label，非必选。

systemctl status k3s
kubectl get node

```

#### master2节点搭建
* 基础软件环境安装
```
sed -i '/k3s-master1/d' /etc/hosts
sed -i '/k3s-master2/d' /etc/hosts
sed -i '/k3s-master3/d' /etc/hosts

echo "192.168.35.11 k3s-master1" >> /etc/hosts
echo "192.168.35.12 k3s-master2" >> /etc/hosts
echo "192.168.35.13 k3s-master3" >> /etc/hosts

systemctl stop firewalld
systemctl disable firewalld

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux


cd /root/k3s/all-rpms
yum install -y *.rpm
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kfp63jaj.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
sudo systemctl restart docker

cd /root/k3s/
docker load < k3s-airgap-images-amd64.tar

reboot

```

* 安装k3s
```
cd /root/k3s/
cd k3s
chmod a+x install.sh k3s
\cp ./k3s /usr/local/bin

export INSTALL_K3S_BIN_DIR=/usr/local/bin
export INSTALL_K3S_SKIP_DOWNLOAD=true
# 填写master1安装时手动指定的token
export INSTALL_K3S_EXEC="--docker --no-deploy traefik --bind-address=192.168.35.12 --node-ip=192.168.35.12 --server https://k3s-master1:6443 --node-label asrole=master --token=3E1AEADCA9BCA0E6523B8766753E9C44 --cluster-cidr=10.128.0.0/16 --service-cidr=10.129.0.0/16 --write-kubeconfig=/root/.kube/config --write-kubeconfig-mode=644 --flannel-iface='eth1'" 
bash install.sh

```

#### master3节点搭建
* 基础软件环境安装
```
sed -i '/k3s-master1/d' /etc/hosts
sed -i '/k3s-master2/d' /etc/hosts
sed -i '/k3s-master3/d' /etc/hosts

echo "192.168.35.11 k3s-master1" >> /etc/hosts
echo "192.168.35.12 k3s-master2" >> /etc/hosts
echo "192.168.35.13 k3s-master3" >> /etc/hosts

systemctl stop firewalld
systemctl disable firewalld

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux


cd /root/k3s/all-rpms
yum install -y *.rpm
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kfp63jaj.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
sudo systemctl restart docker

cd /root/k3s/
docker load < k3s-airgap-images-amd64.tar

reboot

```

* 安装k3s
```
cd /root/k3s/
cd k3s
chmod a+x install.sh k3s
\cp ./k3s /usr/local/bin

export INSTALL_K3S_BIN_DIR=/usr/local/bin
export INSTALL_K3S_SKIP_DOWNLOAD=true
# 填写master1安装时手动指定的token
export INSTALL_K3S_EXEC="--docker --no-deploy traefik --bind-address=192.168.35.13 --node-ip=192.168.35.13 --server https://k3s-master1:6443 --node-label asrole=master --token=3E1AEADCA9BCA0E6523B8766753E9C44 --cluster-cidr=10.128.0.0/16 --service-cidr=10.129.0.0/16 --write-kubeconfig=/root/.kube/config --write-kubeconfig-mode=644 --flannel-iface='eth1'" 
bash install.sh

```

### 集群操作
```
# 删除节点要执行两条命令，一条命令是迁移该节点的所有服务，一条是迁移后删除节点
# 先驱逐节点，会把该节点的数据迁移到其他节点
kubectl drain k3s-master2 --delete-local-data --force --ignore-daemonsets
# 迁移所有服务后，删除节点
kubectl delete nodes k3s-master2


# 删除单个pod
kubectl delete pods nginx-server-1-84b7f79cdf-bbp4p

# 删除flaskapp所有的pod，使用命令
kubectl delete -f /var/server/flask.yaml
 
# 如果images更新了，修改yaml文件，重新应用一遍
kubectl apply -f /var/server/flask.yaml


systemctl status k3s
kubectl get node
cat /var/lib/rancher/k3s/server/node-token
journalctl -xefu k3s

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
```