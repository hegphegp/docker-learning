### 国内终于有kernel镜像源，由中科大提供的
* 先在在这个地址查询最新的内核版本：http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el7/x86_64/RPMS/
```
cat > /etc/yum.repos.d/elrepo.repo << EOF
[elrepo]
name=ELRepo.org Community Enterprise Linux Repository – el7
baseurl=https://mirrors.ustc.edu.cn/elrepo/elrepo/el7/$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
protect=0
[elrepo-testing]
name=ELRepo.org Community Enterprise Linux Testing Repository – el7
baseurl=https://mirrors.ustc.edu.cn/elrepo/testing/el7/$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
protect=0
[elrepo-kernel]
name=ELRepo.org Community Enterprise Linux Kernel Repository – el7
baseurl=https://mirrors.ustc.edu.cn/elrepo/kernel/el7/$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
protect=0
[elrepo-extras]
name=ELRepo.org Community Enterprise Linux Extras Repository – el7
baseurl=https://mirrors.ustc.edu.cn/elrepo/extras/el7/$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
protect=0
EOF
```

#### 升级长期稳定版
```
 yum -y install kernel-lt

# 查看已安装的内核列表
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
# 新安装的内核在列表中排第一位，把新安装的内核启动顺序设置为第一
grub2-set-default 0
shutdown -h now
```

####  升级最新版本
```
 yum -y install kernel-lt

# 查看已安装的内核列表
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
# 新安装的内核在列表中排第一位，把新安装的内核启动顺序设置为第一
grub2-set-default 0
shutdown -h now
```