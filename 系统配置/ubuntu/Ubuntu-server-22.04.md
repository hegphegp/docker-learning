## 全新最小化安装ubuntu-server-22.04

### 配置root密码

```
# sudo -i 命令 是让当前操作的所有命令拥有超级管理员的权限
sudo -i
# echo -e "admin\nadmin" | passwd             # 修改自己的密码
# echo -e "admin\nadmin" | passwd 指定用户名    # 修改指定用户名的密码
echo -e "admin\nadmin" | passwd

# 允许root远程登录
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep UseDNS
cat /etc/ssh/sshd_config | grep GSSAPIAuthentication
cat /etc/ssh/sshd_config | grep PermitRootLogin
sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config ;
sed -ri 's/^PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config ;
sed -ri 's/^GSSAPIAuthentication\s+.*/GSSAPIAuthentication no/' /etc/ssh/sshd_config ;
sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config ;
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep GSSAPIAuthentication
cat /etc/ssh/sshd_config | grep PermitRootLogin
systemctl restart sshd

```

#### 配置静态IP地址
* 最小化安装ubuntu-server-22.04，自带网络配置文件 /etc/netplan/00-installer-config.yaml ，原始内容如下:
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp2s0:
      dhcp4: true
  version: 2
```
* 设置指定IP地址 192.168.0.232
```
tee /etc/netplan/00-installer-config.yaml <<-'EOF'
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp2s0:
      addresses:
      - 192.168.0.232/24
      nameservers:
        addresses: [114.114.114.114]
        search: []
      routes:
      - to: default
        via: 192.168.0.1
  version: 2
EOF
```

#### 修改的apt源，配置阿里云加速器
```
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update && apt-get clean && apt-get autoclean

```

#### 安装lm-sensors获取温度软件，每3秒定时输出温度监控参数
```
apt-get install -y lm-sensors

mkdir -p /opt/monitor

# 创建shell脚本，每3秒输出温度监控数据
tee /opt/monitor/template-monitor.sh <<-'EOF'
#!/bin/bash

while true
do
  date '+%Y-%m-%d %H:%M:%S' >> /opt/monitor/template-monitor.log
  sensors >> /opt/monitor/template-monitor.log
  echo '==========' >> /opt/monitor/template-monitor.log
  # 睡眠3秒
  sleep 3
done
EOF

chmod a+x /opt/monitor/template-monitor.sh


# 创建一个Systemctl服务
tee /lib/systemd/system/template-monitor.service <<-'EOF'

[Unit]
Description=template-monitor
After=network-online.target

[Service]
Type=simple
ExecStart=bash /opt/monitor/template-monitor.sh
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutStartSec=5
RestartSec=2
Restart=always

[Install]
WantedBy=multi-user.target

EOF

systemctl enable template-monitor.service

```

#### 开启ssh隧道，让没外网IP的服务器可以通过互联网访问
* 先连接远程主机，并本地信任远程主机，再设置免密登录
```
ssh root@xx.xx.xx.xx
ssh-keygen -t rsa

ssh-copy-id -i ~/.ssh/id_rsa.pub root@xx.xx.xx.xx

```

* 设置autossh的systemctl服务
```
tee /lib/systemd/system/autossh.service <<-'EOF'
[Unit]
Description=autossh
After=network-online.target

[Service]
Type=simple
#ExecStart=autossh -M 0 -o serverAliveInterval=5 -o ServerAliveCountMax=10 -gfnNTR 1022:127.0.0.1:22 root@xx.xx.xx.xx -p 22
ExecStart=ssh -o serverAliveInterval=10 -o ServerAliveCountMax=10 -gnNTR 1022:127.0.0.1:22 -p 22 root@xx.xx.xx.xx
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutStartSec=5
RestartSec=5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable autossh.service

```

##### 每7天重启一次
```
crontab -e
shutdown -r 1 命令，表示1分钟后重启
# 13 2 1,7,15,21,28 * * /usr/sbin/shutdown -r 1
13 2 1,7,15,21,28 * * /usr/sbin/shutdown -r 1
```