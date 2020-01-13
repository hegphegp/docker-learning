## Centos7安装docker

```
yum remove docker docker-common docker-selinux docker-engine
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i "/mirrors.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
sed -i "/mirrors.cloud.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
source /etc/profile
yum clean all
yum makecache
systemctl stop firewalld && systemctl disable firewalld && systemctl stop firewalld
yum install -y docker-ce
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
systemctl restart docker
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

#### docker解压安装包的下载地址  https://mirrors.aliyun.com/docker-ce/linux/static/stable/x86_64/
#### 全部用centos7的镜像测试纯净centos7安装各种docker版本的软件依赖
```
docker stop centos && docker rm centos
docker run -itd --name centos --privileged centos:7.6.1810 /usr/sbin/init
docker exec -it centos sh
cd /
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i "/mirrors.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
sed -i "/mirrors.cloud.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
mkdir -p 18.03.1 && mkdir -p 18.06.3 && mkdir -p 18.09.5 
yum install --downloadonly --downloaddir=18.03.1 docker-ce-18.03.1.ce
yum install --downloadonly --downloaddir=18.06.3 docker-ce-18.06.3.ce
yum install --downloadonly --downloaddir=18.09.5 docker-ce-18.09.5
exit
# 停止copy
rm -rf docker-ce-18.03.1 docker-ce-18.06.3 docker-ce-18.09.5
docker cp centos:/18.03.1 docker-ce-18.03.1
docker cp centos:/18.06.3 docker-ce-18.06.3
docker cp centos:/18.09.5 docker-ce-18.09.5
```

#### Centos下载指定版本的软件安装包和依赖，不安装软件，下载相应的docker版本软件到指定目录
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i "/mirrors.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
sed -i "/mirrors.cloud.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum clean all
yum makecache
mkdir -p hgp/docker-install-packages/18.09
yum install --downloadonly --downloaddir=hgp/docker-install-packages/18.09 docker-ce-18.09.3
```

#### 配置docker的yum源，列出docker的软件安装包版本
```
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum list docker-ce --showduplicates | sort -r
# yum install --downloadonly --downloaddir=18.03.1 docker-ce-18.03.1.ce
# yum install --downloadonly --downloaddir=18.06.3 docker-ce-18.06.3.ce
# yum install --downloadonly --downloaddir=18.09.3 docker-ce-18.09.3
#  * updates: mirrors.aliyun.com
# Loading mirror speeds from cached hostfile
# Loaded plugins: fastestmirror
#  * extras: mirrors.aliyun.com
# docker-ce.x86_64            3:18.09.3-3.el7                     docker-ce-stable
# docker-ce.x86_64            3:18.09.2-3.el7                     docker-ce-stable
# docker-ce.x86_64            3:18.09.1-3.el7                     docker-ce-stable
# docker-ce.x86_64            3:18.09.0-3.el7                     docker-ce-stable
# docker-ce.x86_64            18.06.3.ce-3.el7                    docker-ce-stable
# docker-ce.x86_64            18.06.2.ce-3.el7                    docker-ce-stable
# docker-ce.x86_64            18.06.1.ce-3.el7                    docker-ce-stable
# docker-ce.x86_64            18.06.0.ce-3.el7                    docker-ce-stable
# docker-ce.x86_64            18.03.1.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            18.03.0.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.12.1.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.12.0.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.09.1.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.09.0.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.06.2.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.06.1.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.06.0.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.03.3.ce-1.el7                    docker-ce-stable
# docker-ce.x86_64            17.03.2.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.03.1.ce-1.el7.centos             docker-ce-stable
# docker-ce.x86_64            17.03.0.ce-1.el7.centos             docker-ce-stable
#  * base: mirrors.aliyun.com
```

[Centos7的阿里云docker安装包下载地址https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/](https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/)  
[docker-compose的官方下载地址https://github.com/docker/compose/releases/](https://github.com/docker/compose/releases/)  
[docker-compose的阿里云下载地址https://mirrors.aliyun.com/docker-toolbox/linux/compose/](https://mirrors.aliyun.com/docker-toolbox/linux/compose/)  
[docker-machine的官方下载地址https://github.com/docker/machine/releases/](https://github.com/docker/machine/releases/)  
[docker-machine的阿里云下载地址https://mirrors.aliyun.com/docker-toolbox/linux/machine/](https://mirrors.aliyun.com/docker-toolbox/linux/machine/)  
[香港内核仓库http://hkg.mirror.rackspace.com/elrepo/kernel/el7/x86_64/RPMS/](http://hkg.mirror.rackspace.com/elrepo/kernel/el7/x86_64/RPMS/)  
[清华大学内核仓库https://mirrors.tuna.tsinghua.edu.cn/elrepo/kernel/el7/x86_64/RPMS/](https://mirrors.tuna.tsinghua.edu.cn/elrepo/kernel/el7/x86_64/RPMS/)  
[中国科技大学内核仓库http://mirrors.ustc.edu.cn/elrepo/kernel/el7/x86_64/RPMS/](http://mirrors.ustc.edu.cn/elrepo/kernel/el7/x86_64/RPMS/)  
[内核仓库http://elrepo.reloumirrors.net/kernel/el7/x86_64/RPMS/](http://elrepo.reloumirrors.net/kernel/el7/x86_64/RPMS/)  
[内核仓库http://elrepo.org/linux/kernel/el7/x86_64/RPMS/](http://elrepo.org/linux/kernel/el7/x86_64/RPMS/)  
[内核仓库http://ftp.colocall.net/pub/elrepo/archive/kernel/el6/x86_64/RPMS/](http://ftp.colocall.net/pub/elrepo/archive/kernel/el6/x86_64/RPMS/)  

* 1.卸载自带的docker服务
* 2.切换成阿里的yum源
* 3.升级内核，并把该内核启动顺序设置为第一
* 4.安装docker，并设置阿里docker加速器
* 5.安装docker-compose
* 6.安装docker-machine

> #### 1.卸载自带的docker服务
```
yum remove docker docker-common docker-selinux docker-engine
```

> #### 2.更换yum源
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i "/mirrors.cloud.aliyuncs.com/d"  /etc/yum.repos.d/CentOS-Base.repo
echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
source /etc/profile
yum clean all
yum makecache
```

> #### 3.升级内核，并把该内核启动顺序设置为第一
```
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/elrepo/kernel/el7/x86_64/RPMS/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
# yum install -y http://hkg.mirror.rackspace.com/elrepo/kernel/el7/x86_64/RPMS/kernel-lt-4.4.169-1.el7.elrepo.x86_64.rpm    //香港镜像仓库
yum --enablerepo=elrepo-kernel install kernel-lt -y
# 查看当前默认内核
grub2-editenv list
# 查看所有内核版本
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
# 设置刚刚安装的内核版本启动顺序为第一
grub2-set-default 0
```

> #### 4.安装18.03版本docker，并设置阿里docker加速器
```
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine docker-ce
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
# yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-18.09.0-3.el7.x86_64.rpm 
# yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-18.09.0-3.el7.x86_64.rpm 

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF
systemctl enable docker #设置docker服务开机自启动
sudo systemctl restart docker

# 生产环境一定要加graph选项，指定docker镜像和日志的目录为大空间的目录，否则死的时候武眼睇
# echo $PASSWD | sudo tee /etc/docker/daemon.json <<-'EOF'
# {
#    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"],
#    "graph": "/opt/data/docker"
# }
# EOF
```

> #### 5.安装docker-compose
```
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

> #### 6.安装docker-machine
```
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/machine/0.15.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
```
