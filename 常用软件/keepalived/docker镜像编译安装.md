#### 编译安装keepalived

> Keepalived工作原理是VRRP，所以只能在同一局域网的主机中使用
> Ipvs(IP Virtual Server)是整个负载均衡的基础，如果没有这个基础，故障隔离与失败切换就毫无意义了。
* 先安装ipvsadm
```
yum -y install ipvsadm
# 执行
ipvsadm
# 只有执行ipvsadm以后，才会在内核加载ip_vs模块。
# 检查当前加载的内核模块，看是否存在ip_vs模块 
lsmod|grep ip_vs 
```

##### 过来人的痛, 放弃用Ubuntu编译 keeplived , 全世界的博客都是用centos编译keeplived的, 编译依赖缺失时, 博客有解决方案. 如果用 Ubuntu 编译, 出错了都找不到原因.
* 源码下载地址 https://www.keepalived.org/software/
```
mkdir -p keepalived
docker run -it --rm -v $PWD/keepalived:/keepalived centos:7.6.1810 bash
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all && yum makecache && yum install -y gcc openssl-devel libnl-devel make
cd /keepalived
curl https://www.keepalived.org/software/keepalived-2.0.19.tar.gz > keepalived-2.0.19.tar.gz
tar -zxvf keepalived-2.0.19.tar.gz -C .
mkdir -p keepalived-2.0.19-bin
cd keepalived-2.0.19
./configure --prefix=/keepalived/keepalived-2.0.19-bin

# 自定义源代码编译后, 运行make install命令, 在真正的虚拟机或者服务器, 
# 会在 /lib/systemd/system/ 路径下生成 keepalived.service 服务开机启动的配置文件, 在docker容器里面没有生成, 该配置文件的内容

tee keepalived.service <<-'EOF'
[Unit]
Description=LVS and VRRP High Availability Monitor
After=network-online.target syslog.target 
Wants=network-online.target 

[Service]
Type=forking
PIDFile=/run/keepalived.pid
KillMode=process
EnvironmentFile=-/配置文件路径/etc/sysconfig/keepalived
ExecStart=/可运行文件路径/sbin/keepalived $KEEPALIVED_OPTIONS
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

EOF

```