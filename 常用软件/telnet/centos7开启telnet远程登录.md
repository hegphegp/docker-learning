# centos7开启telnet远程登录
* centos7自带ssh服务是低版本的, 存在漏洞, ssh要升级到高版本, 升级过程中要ssh服务要关掉, 因此要开启Telnet服务远程登录

#### 步骤一 配置阿里云yum源仓库 
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
source /etc/profile
yum clean all
yum makecache
```

#### 步骤二 查看telnet-server软件是否已经安装(客户端可以安装也可以不安装,不过telnet命令经常用,因此也建议安装客户端)
```
# 查看是否已安装的telnet rpm包*
rpm -qa | grep telnet
# 查看仓库telnet安装包版本
yum list | grep telnet
# 如果没安装Telnet软件, 就安装
yum install -y telnet*
```

```
systemctl enable telnet.socket
systemctl start telnet.socket
useradd hadoop
echo -e "hadoop\nhadoop" | passwd core
echo "" > passwd hadoop
```