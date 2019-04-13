# Centos常用命令

#### Centos和Ubuntu查看软件开机的启动时间
```
systemd-analyze blame
```

#### 查看具体的Centos版本(下面任意一条命令)
```
cat /etc/redhat-release
rpm -q centos-release
lsb_release -a   # 事先必须先安装好 lsb_release 这个工具
```

```
# 打包命令，参数z是压缩

# 1) 打包指定文件夹，正确的命令格式只有下面这一条，到时候出问题了就跪掉了
tar cvf idea.tar.gz -C /home/hgp/workspace idea
# 2) 与上面对应的解压命令是
tar -xvf idea.tar.gz -C /home/hgp/workspace

# tar压缩当前目录(如果目录有空格的话，命令会执行失败)
WORKPATH=$PWD && tar -czvf $(basename `pwd`).tar.gz -C $WORKPATH $(ls -all $WORKPATH)
# 压缩指定文件夹
tar -czvf postgres-idc.tar.gz postgres

# tar解压到指定文件夹
tar -zxvf dapeng.tar.gz -C /data/nginx/html
```

### yum下载相关依赖包
```
mkdir -p /opt/packages/dockerRepo/18.06.1
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install --downloadonly --downloaddir=/opt/packages/dockerRepo/18.06.1 docker-ce-18.06.1.ce-3.el7.x86_64
cd /opt/packages/dockerRepo/18.06.1
ls

mkdir -p /opt/packages/mysqlRepo
yum install --downloadonly --downloaddir=/opt/packages/mysqlRepo mysql
cd /opt/packages/mysqlRepo
ls
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
# tcp6       0      0 127.0.0.1:52057         :::*                    LISTEN      7648/java
# tcp6       0      0 :::3306                 :::*                    LISTEN      4542/mysql
# tcp6       0      0 :::34699                :::*                    LISTEN      7648/java

# 关掉3306端口的服务进程
kill -9 4542
```

### Linux查看java进程开启的线程以及数量
```
# Linux查看java进程开启的线程
top -H -p {pid}
# Linux查看java进程开启的线程数量
ps huH p  {pid}  | wc -l
```

### Linux搜索指定路径下的文件内容
```
# grep加-i参数不区分大小写
grep -rni "netty" .
grep -rn -i "netty" /opt/soft
# grep指定搜索指定的后缀名
grep -R -n -i --include="*.java" "netty" .
grep -R -n -i --inssh-agent bash
ssh-add id_rsa
ssh root@121.201.65.133lude="*.java" "netty" /opt/soft
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

### alpine apk 安装指定版本的软件
```
apk add python2=2.7.14-r2
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

#### docker的常见问题
* Failed to get D-Bus connection: Operation not permitted
- 报这个错的原因是dbus-daemon没能启动。并不是容器里面systemctl不能使用
```
# 启动的时候加 --privileged 参数
# 将CMD或者entrypoint设置为/usr/sbin/init即可。docker容器会自动将dbus等服务启动起来。
```