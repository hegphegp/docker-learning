# Centos常用命令

* [目录]
    * [git的Socket5代理](git的Socket5代理)
    * [tree忽略某些文件夹](tree忽略某些文件夹)

#### git的Socket5代理 , tree忽略某些文件夹
```
# 优先使用临时代理，亲测，好像该代理只对git命令生效，对curl命令不生效
ALL_PROXY=socks5://127.0.0.1:1080 git clone git@github.com:hegphegp/docker-learning.git  # 对git命令生效
ALL_PROXY=socks5://127.0.0.1:1080 git clone https://github.com/pkaq/ant-design-pro.git  # 对git命令生效
ALL_PROXY=socks5://127.0.0.1:1080 curl https://www.google.com/ # 对curl命令无效

# git全局配置socks5代理
# # git config --global http.proxy 'socks5://127.0.0.1:1080'
# # git config --global https.proxy 'socks5://127.0.0.1:1080'


# git清除socks5代理
# # git config --global --unset http.proxy
# # git config --global --unset https.proxy
```

#### tree忽略某些文件夹
```
# -I 命令使用正则匹配来排除文件夹
tree -I "node_modules"
# 也可以使用 | 同时排除多个文件夹
tree -I "node_modules|cache|test_*"
# 只看两级目录
tree -L 2
```

#### 查看目录的使用空间的大小
```
# 查看所有首层文件夹的大小
du -h / --max-depth=1
# 查看/var路径下的首层文件夹的大小
du -h /var --max-depth=1
```

#### Centos和Ubuntu查看软件开机的启动时间
```
systemd-analyze blame
```

tree -I "node_modules"

#### 多线程下载工具 axel , 下载国外资源时比较快
```
yum install -y axel
#  使用方法
#  限速使用：加上 -s 参数，如 -s 10240，即每秒下载的字节数，这里是 10 Kb
#  限制连接数：加上 -n 参数，如 -n 5，即打开 5 个连接
axel -a -n 10 http://downloadUrl
```

#### 查看具体的Centos版本(下面任意一条命令)
```
cat /etc/redhat-release
rpm -q centos-release
lsb_release -a   # 事先必须先安装好 lsb_release 这个工具
```

#### 在/etc/profile.d目录下配置环境变量
```
# 配置gradle环境
mkdir -p /etc/profile.d
tee /etc/profile.d/gradle.sh <<-'EOF'
# set gradle environment
export GRADLE_HOME=/opt/soft/gradle/gradle-4.10.3
export PATH=$PATH:$GRADLE_HOME/bin
EOF
chmod a+x /etc/profile.d/gradle.sh

# 配置gradle环境
mkdir -p /etc/profile.d
tee /etc/profile.d/java.sh <<-'EOF'
# set java environment
export JAVA_HOME=/opt/soft/java/jdk1.8.0_222
export JRE_HOME=/opt/soft/java/jdk1.8.0_222/jre
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/lib:$JRE_HOME/bin:$JRE_HOME/lib
EOF
chmod a+x /etc/profile.d/java.sh
```

#### 解压缩文件夹目录
```
# 压缩命令，参数z是压缩, 加上z参数, 大文件目录打包压缩会很慢
# tar压缩当前目录
tar -czvf ../$(basename `pwd`).tar.gz .

# 压缩指定文件夹
tar -czvf postgres-idc.tar.gz postgres

# tar解压到指定文件夹
tar -zxvf dapeng.tar.gz -C /data/nginx/html
```

#### 批量递归把子孙文件夹的文件转码, 并替换旧的文件
```
find 要转码的文件件夹 -type f -exec iconv -f 原来的编码 -t 转码后的编码 {} -o {} \;
# find 文件夹 -type f -exec iconv -f GBK -t UTF-8 {} -o {} \;
```

#### 批量递归把子孙文件夹的文件转码到另外的文件夹
```
# 递归创建目录结构
find 要转码的文件件夹 -type d -exec mkdir -p 新文件夹/{} \;
# find default -type d -exec mkdir -p utf/{} \;
find 要转码的文件件夹 -type f -exec iconv -f 原来的编码 -t 转码后的编码 {} -o 新文件夹/{} \;
# find 要转码的文件件夹 -type f -exec iconv -f GBK -t UTF-8 {} -o 新文件夹/{} \;
```

### yum下载软件离线安装包和依赖包
```
mkdir -p /opt/packages/dockerRepo/18.06.1
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install --downloadonly --downloaddir=/opt/packages/dockerRepo/18.06.1 docker-ce-18.06.1.ce-3.el7.x86_64
```

##### 查看指定端口服务的PID
```
netstat -nlp | grep :8080 | awk '{print $7}' | awk -F"/" '{ print $1 }'
```

##### 关掉指定端口的服务
```
kill -9 $(netstat -nlp | grep :8080 | awk '{print $7}' | awk -F"/" '{ print $1 }')
```

### Linux查看服务监听的端口
```
yum install net-tools
netstat -antu
netstat -tunlp
netstat -antu | grep LISTEN
# Ubuntu查看指定的端口占用情况
# lsof -i:9898

netstat -ntpl # 等同于 netstat -antu | grep LISTEN  或者等同于  netstat -tunlp | grep LISTEN 
# Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
# tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1557/sshd
# tcp        0      0 127.0.0.1:6942          0.0.0.0:*               LISTEN      6211/java
# tcp6       0      0 :::22                   :::*                    LISTEN      1557/sshd
```

### Linux查看某个进程开启的线程以及数量
```
# Linux查看某个进程开启的线程
top -H -p {pid}
# Linux查看某个进程开启的线程数量
ps huH p  {pid}  | wc -l
```

### Linux搜索指定路径下的文件内容
```
# 查找子孙文件夹下包含指定字符串的文件名
grep   -lr   'import'   .
# 要将当前目录的下面所有文件中的old都修改成new，这样做：
sed   -i   's|old|new|g'   `grep   'old'   -rl   .`

# grep加-i参数不区分大小写
grep -rni "netty" .
grep -rn -i "netty" /opt/soft
# grep指定搜索指定的后缀名
grep -R -n -i --include="*.java" "netty" .
grep -R -n -i --include="*.java" "netty" /opt/soft
# 忽略指定的目录
grep --exclude-dir="node_modules" -rni "netty" .
```

### 被坑死过的命令
```
# sed要覆盖替换文件，必须加 -ri 参数
# -i表示替换，       -i[SUFFIX], --in-place[=SUFFIX] edit files in place (makes backup if SUFFIX supplied)
# -r表示正则表达式，  -r, --regexp-extended use extended regular expressions in the script.
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config ;
```

#### 释放centos7 缓存
```
echo 3 > /proc/sys/vm/drop_caches
```

##### 查看前面n行或者最后n行数据
```
tail -n 1000 /aa.txt  # 打印文件最后1000行的数据
tail -n +1000 /aa.txt # 打印文件第1000行开始以后的内容
head -n 1000 /aa.txt  # 打印前1000的内容
sed -n '1000,3000p' filename  # 显示1000到300行的数据
```

### 访问nginx时，nginx提示403，日志打印没权限的解决方法
```
# chown -R 用户名 .
# chmod -R 655 .
chmod -R 655 目录
```

### alpine apk 安装指定版本的软件
```
apk add python2=2.7.14-r2
```

### Linux下iconv转换文件从GBK到UTF-8
```
iconv -f gbk -t utf-8 source-file -o target-file
```

### Linux禁止删除文件夹

* 在Ubuntu实验时，发现root用户可以chattr命令，普通用户加上sudo也可以使用chattr命令，普通用户直接输入chattr命令，Ubuntu不会提示没权限，提示了人看不懂含义的警告
* 对某个文件夹使用chattr命令后，该文件夹内就不能创建文件夹和文件了，但是该文件夹内的子文件夹可以创建文件和文件夹
```json
mkdir -p workspace/son
echo 'qqqqqqqqqqqq' >> workspace/son.txt
# sudo chattr +i workspace/
echo "密码" | sudo -S chattr +i workspace/

# 通过查看当前路径下的文件和文件夹的lsattr属性
lsattr $PWD
# ----i---------e--- /当前路径/workspace      # 输出结果

# 执行下面删除命令，创建子文件和创建子文件夹命令，提示 `不允许的操作`
rm -rf workspace/son
# rm: 无法删除'workspace/son': 不允许的操作
rm -rf workspace/son.txt
# rm: 无法删除'workspace/son.txt': 不允许的操作
mkdir -p workspace/son1
# mkdir: 无法创建目录"workspace/son1": 不允许的操作
echo 'qqqqqqqqqqqq' >> workspace/son1.txt
# bash: workspace/son1.txt: 不允许的操作

# 可以修改直属子文件
echo 'qqqqqqqqqqqq' >> workspace/son.txt

# 删除权限
echo "密码" | sudo -S chattr -i workspace/
lsattr $PWD
# --------------e--- /当前路径/workspace      # 输出结果
```

#### 获取kernel-ml离线安装包(内终于有kernel镜像源，由中科大提供的)
```
# 载入公钥
# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# 安装ELRepo
# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
# yum --disablerepo=\* --enablerepo=elrepo-kernel list kernel* # 查询内核安装包列表
# yum list kernel*   # 查出来的仓库地址是香港的 hkg.mirror.rackspace.com 
cat > /etc/yum.repos.d/elrepo.repo << "EOF"
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


mkdir -p kernel-ml
yum --enablerepo=elrepo-kernel install --downloadonly --downloaddir=kernel-ml kernel-ml-devel kernel-ml
tar -czvf kernel-ml.tar.gz kernel-ml

# 查看已安装的内核列表
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
# 新安装的内核在列表中排第一位，把新安装的内核启动顺序设置为第一
grub2-set-default 0
```


#### shell脚本关闭指定端口的服务
```
#!/bin/bash

serverPort=8888
currentPath=$(cd "$(dirname "$0")"; pwd)
echo "current path:"${currentPath}
cd ${currentPath}

# kill -9 $(netstat -nlp | grep :8080 | awk '{print $7}' | awk -F"/" '{ print $1 }')
# shell脚本给变量赋值，等号两边不能有括号，否则死的时候武眼睇
PID=$(netstat -nlp | grep :${serverPort} | awk '{print $7}' | awk -F"/" '{ print $1 }')
if [ "" != "$PID" ]; then
  echo "close service in port "${serverPort}
  kill -9 $PID
fi
java -Xmx2560m -Xms256m -Xmn128m -Xss1m -jar ${currentPath}/icity-admin-service-1.0.0-SNAPSHOT.jar --server.port=${serverPort} >> ${currentPath}/log.log &

```