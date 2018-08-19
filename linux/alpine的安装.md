# alpine安装
## 在alpine系统安装的过程中，死过几次，可能以后都按以下步骤，否则死了怪不了别人
### 无尽的痛苦和死亡，得出的结论是alpine官方根本不可信
* 死过无数次，按setup-alpine的步骤配置完后，我查看/etc/network/interfaces文件是存在的，此时hostname为设置的名称，按官方的提示，配置完重启后，再进入系统，一切的配置都消失了，hostname变成了localhost，配置/etc/network/interfaces不见了，还可以相信世界吗？

* 安装版本a lpine-standard-3.8.0-x86_64.iso
* 虚拟机工具virtualbox
* 新建一台虚拟机，类型选Linux，版本选 Other Linux(64-bit)，然后配置网络地址转换(NAT)
### 死过一次的说明，创建虚拟机时配置了双网卡双网卡 网络地址转换(NAT)和仅主机(Host-Only)网卡。setup-alpine配置安装向导时，两个网卡参数全部默认，居然访问不了网络，导致后续步骤要联网下载依赖失败
### 既然死过一次，以后创建apline虚拟机时，先创建一张网卡， setup-alpine设置完向导后再配置多一张网卡
### 必须选单网卡，因为无法区分哪个网卡对应eth0或者eth1，centos的安装界面是可以看出哪个网卡对应的名称的，alpine不行

#### 1）启动虚拟机，首次启动时使用root这个用户名登录，不需要密码
#### 2）登录后，执行 setup-alpine 命令进入安装向导，向导会询问你一系列的问题。如果途中操作有失误，可以按Ctrl + c退出向导，再重新开始向导
#### 3）安装向导的每个问题的含义
```
Select keyboard layout [none]:  
# 选择键盘布局，系统默认给你选了none，直接回车

Enter system hostname (short form, e.g. 'foo') [localhost]
# 选择虚拟机host名称，系统给你选了localhost，没有特殊需要的话直接回车

Which one do you want to initialize? (or '?' or 'done') [eth0]
# 选择要不要设置网卡，系统给你选了需要初始化eth0那张网卡，直接回车

# 在下面这个配置死过一次，必须配置IP，如果选了dhcp，重启后就不会有IP，同时/etc/network/interfaces这个网络配置文件也不会存在
Ip address for eth0? (or 'dhcp', 'none', '?') [dhcp]
# 找到网络地址转换(NAT)网卡对应的网段，然后分配一个固定IP
# 输入eth0网卡的IP地址

Do you want to do any manual network configuration? [no]
# 必须填yes进来修改网络信息，否则不会生成/etc/network/interfaces文件，重启系统后，虚拟机的网络就是死了

# 因为上步选择了手动配置网络信息，会多出以下两项项信息填写

DNS domain name?(e.g 'bar.com')[]
# 直接回车

# DNS nameserver(s)?[]
# 直接回车

Changeing password for root
New password:
# 安装完成后，就不能像现在这样不用密码就登录了，系统提示你输入root帐号的密码。
Retype Password:
# 确认一遍密码

Which timezone are you in? ('?' for list) [UTC]
# 输入时区，国内可以输入"Asia/Shanghai"

HTTP/FTP pxory URL?(e.g. 'http://proxy:8080', or 'none')[none]
# 需要使用HTTP代理连接网络吗？一般不需要，可以直接回车

Enter mirror number (1-21) or URL to add (or r/f/e/done) [f]
# 最最关键的一步，这步必须确保虚拟机联网，不联网会有问题。不知道是不是配了双网卡，还是其他问题，导致网络无法访问，百度也ping不通
# 只能选r，让它出错，然后会跳过这个，但是后面的步骤会有很多错误，因为后续步骤需要联网下载依赖，访问不了网络，导致出错
# Alpine Linux自带的包管理器需要联网下载软件包,要是想使用中文镜像就输入e编辑，不然就随机选个吧。 

Which SSH server? ('openssh', 'dropbear' or 'none') [openssh]
# SSH服务器（用于登录Linux）有两种可供选择，默认选择openssh，回车

Which NTP client to run? ('busybox', 'openntpd', 'chorony' or 'none') [chrony]
# 选择NTP客户端(用来调整系统时钟)的类型，保持默认的chrony即可，回车

Available disks are:
  sda   (8.6 GB ATA    VBOX HARDDISK    )
Which disk(s) would you like to use? (or '?' for help or 'none') [none]
# 输入sda
# 这一步比较关键，系统发现了有块8.6GB大小，名称叫sda的硬盘，问你需不需要使用硬盘，
# 因为Alpine Linux可以运行在内存里，这里的默认选项是不使用硬盘，所以要手动键入sda，后面的步骤才会将系统安装在硬盘上

The following disk is selected:
  sda   (8.6 GB ATA      VBOX HARDDISK    )
How would you like to use it? ('sys', 'data', 'lvm' or '?' for help) [?]
# 以何种方式安装系统，这里需要键入"sys"，表示把整个系统安装在硬盘上。其他选项并不适用于虚拟机

WARNING: The following disk(s) will be erased:
  sda   (8.6 GB ATA      VBOX HARDDISK   )
WARNING: Erase the above disk(s) and continue? [y/N]
# 世纪巨坑
# 向导让你确认选择的sda磁盘上的数据会全部丢失，键入"y"确认

# 如果你的虚拟机硬盘之前安装过别的，可能会提示如下
# /dev/sda1 contains a ext4 file system
# Proceed anyway(y,N)
# 输入"y"继续啦...

# 因为配置完虚拟机后，直接poweroff而不知reboot，在这里死过一次，后面再启动机器时，发现之前的/etc/network/interfaces不存在了
# 配置完之后，必须手动输入reboot重启虚拟机，
```

#### 给虚拟机添加一张网卡
