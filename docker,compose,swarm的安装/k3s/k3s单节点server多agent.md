### k3s单节点server多agent
* 没使用--datastore-endpoint时，k3s都是单server模式的

##### 环境搭建，先用vagrant创建两台服务器，然后每个节点的/root/k3s/all-rpms准备好所有rpm安装包（找台全新的虚拟机，使用yum下载离线安装包），/root/k3s目录准备好k3s安装文件

##### 下载离线安装包
```
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i "/mirrors.cloud.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum clean all && yum makecache
yum list docker-ce --showduplicates | sort -r
mkdir -p all-rpms
yum install --downloadonly --downloaddir=all-rpms docker-ce-19.03.12
rpm -i https://rpm.rancher.io/k3s-selinux-0.1.1-rc1.el7.noarch.rpm
yum install --downloadonly --downloaddir=all-rpms container-selinux selinux-policy-base

```
[install.sh安装脚本的下载地址 https://docs.rancher.cn/k3s/k3s-install.sh](https://docs.rancher.cn/k3s/k3s-install.sh)  
[k3s二进制文件的下载地址 https://github.com/rancher/k3s/releases](https://github.com/rancher/k3s/releases)  
[k3s依赖镜像的下载地址 https://github.com/rancher/k3s/releases](https://github.com/rancher/k3s/releases)  

#### 
```
sed -i '/k3s-master1/d' /etc/hosts
sed -i '/k3s-agent1/d' /etc/hosts

echo "192.168.35.11 k3s-master1" >> /etc/hosts
echo "192.168.35.12 k3s-agent1" >> /etc/hosts

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

################# 停止copy ##################################

# k3s-master节点
cd /root/k3s/
chmod a+x install.sh k3s
\cp ./k3s /usr/local/bin
export INSTALL_K3S_BIN_DIR=/usr/local/bin
export INSTALL_K3S_SKIP_DOWNLOAD=true
export INSTALL_K3S_EXEC="--docker --no-deploy traefik --bind-address=192.168.35.11 --node-ip=192.168.35.11"
bash install.sh

systemctl status k3s
kubectl get node


# k3s-agent1节点
cd /root/k3s/
chmod a+x install.sh k3s
\cp ./k3s /usr/local/bin
export INSTALL_K3S_BIN_DIR=/usr/local/bin
export INSTALL_K3S_SKIP_DOWNLOAD=true
export INSTALL_K3S_EXEC="--docker --no-deploy traefik --bind-address=192.168.35.11 --node-ip=192.168.35.11"
bash install.sh

systemctl status k3s
kubectl get node
cat /var/lib/rancher/k3s/server/node-token

# manager1节点
cd /root/k3s/
cd k3s
chmod a+x install.sh k3s
\cp ./k3s /usr/local/bin
# export INSTALL_K3S_BIN_DIR=/usr/local/bin
# export INSTALL_K3S_SKIP_DOWNLOAD=true 
# export K3S_URL=https://k3s-master1:6443 
# export K3S_TOKEN=K10837211630afbb920dfdf075890dc79a2e3e7585ab93cd1b050cf1ac0edd423fb::server:e9e81af4828bbeb5e7f585ecf5368f4c 
# export INSTALL_K3S_EXEC="--docker --no-deploy traefik --server https://k3s-master1:6443 --bind-address=192.168.35.12 --node-ip=192.168.35.12 --token=K10837211630afbb920dfdf075890dc79a2e3e7585ab93cd1b050cf1ac0edd423fb::server:e9e81af4828bbeb5e7f585ecf5368f4c"
# bash install.sh

export INSTALL_K3S_BIN_DIR=/usr/local/bin
export INSTALL_K3S_SKIP_DOWNLOAD=true 
export INSTALL_K3S_EXEC="--docker --no-deploy traefik --bind-address=192.168.35.12 --node-ip=192.168.35.12 --node-label asrole=worker" 
export K3S_URL=https://k3s-master1:6443 
export K3S_TOKEN=K10837211630afbb920dfdf075890dc79a2e3e7585ab93cd1b050cf1ac0edd423fb::server:e9e81af4828bbeb5e7f585ecf5368f4c 
bash install.sh

# 在k3s-master1删除一个节点
# 先驱逐节点，会把该节点的数据迁移到其他节点
kubectl drain k3s-master2 --delete-local-data --force --ignore-daemonsets
# 删除节点
kubectl delete nodes k3s-master2
```