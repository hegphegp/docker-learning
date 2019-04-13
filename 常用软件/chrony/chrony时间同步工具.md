### chrony时间同步工具

* Chrony是一个开源的自由软件，像CentOS-7或基于RHEL-7操作系统，已经是默认服务，默认配置文件在 /etc/chrony.conf 它能保持系统时间与时间服务器（NTP）同步，让时间始终保持同步。相对于NTP时间同步软件，占据很大优势。其用法也很简单。

#### /etc/chrony.conf默认配置文件的说明
```
# 使用pool.ntp.org项目中的公共服务器。以server开，理论上你想添加多少时间服务器都可以。
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst

# 根据实际时间计算出服务器增减时间的比率，然后记录到一个文件中，在系统重启后为系统做出最佳时间补偿调整。
driftfile /var/lib/chrony/drift

# chronyd根据需求减慢或加速时间调整，
# 在某些情况下系统时钟可能漂移过快，导致时间调整用时过长。
# 该指令强制chronyd调整时期，大于某个阀值时步进调整系统时钟。
# 只有在因chronyd启动时间超过指定的限制时（可使用负值来禁用限制）没有更多时钟更新时才生效。
makestep 1.0 3

# 将启用一个内核模式，在该模式中，系统时间每11分钟会拷贝到实时时钟（RTC）。
rtcsync

# Enable hardware timestamping on all interfaces that support it.
# 通过使用hwtimestamp指令启用硬件时间戳
#hwtimestamp eth0
#hwtimestamp eth1
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# 指定一台主机、子网，或者网络以允许或拒绝NTP连接到扮演时钟服务器的机器
#allow 192.168.0.0/16
#deny 192.168/16

# Serve time even if not synchronized to a time source.
local stratum 10

# 指定包含NTP验证密钥的文件。
#keyfile /etc/chrony.keys

# 指定日志文件的目录。
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking
```

#### 具体操作
* 配置完/etc/chrony.conf后，需重启chrony服务，否则可能会不生效。
```
docker stop chrony01 chrony02
docker rm chrony01 chrony02
docker network rm chrony-network
docker network create --subnet=10.10.57.0/24 chrony-network
docker run --privileged -itd --restart always --net chrony-network --ip 10.10.57.101 --name chrony01 centos:7.6.1810 /usr/sbin/init
docker run --privileged -itd --restart always --net chrony-network --ip 10.10.57.102 --name chrony02 centos:7.6.1810 /usr/sbin/init

docker exec -it chrony01 sh
echo -e "nameserver 202.96.134.133 \nnameserver 202.96.128.166" > /etc/resolv.conf
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install chrony -y
systemctl enable chronyd.service
sed -i 's|^server|# server|g' /etc/chrony.conf
echo "server ntp1.aliyun.com iburst" >> /etc/chrony.conf
echo "server ntp2.aliyun.com iburst" >> /etc/chrony.conf
# server ntp3.aliyun.com iburst
# .............................
# server ntp7.aliyun.com iburst

systemctl restart chronyd.service
chronyc -a makestep
chronyc sourcestats
chronyc sources -v

exit

docker exec -it chrony02 sh
echo -e "nameserver 202.96.134.133 \nnameserver 202.96.128.166" > /etc/resolv.conf
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install chrony -y
systemctl enable chronyd.service
sed -i 's|^server|# server|g' /etc/chrony.conf
echo "server 10.10.57.101 iburst" >> /etc/chrony.conf
systemctl restart chronyd.service
chronyc -a makestep
chronyc sourcestats
chronyc sources -v

```

### 常用命令
```
# 查看时间同步源
chronyc sources -v
# 查看时间同步源状态
chronyc sourcestats -v
# 设置硬件时间
# 硬件时间默认为UTC
timedatectl set-local-rtc 1
# 启用NTP时间同步
timedatectl set-ntp yes
# 校准时间服务器
chronyc tracking
```