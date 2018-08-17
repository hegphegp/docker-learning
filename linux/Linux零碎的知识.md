# Linux零碎的知识

* [Linux零碎的知识]()
  * [centos]()
  * [ubuntu]()
    * [查看Ubuntu版本](#查看Ubuntu版本)
  * [alpine]()
    * [alpine apk 安装指定版本的软件](#安装指定版本的软件)
  * [公共]()
    * [解压缩命令](#压缩命令)
    * [查看指定端口服务的PID](#查看指定端口服务的PID)
    * [关掉指定端口的服务](#关掉指定端口的服务)
    * [Linux搜索指定路径下的文件内容](#Linux搜索指定路径下的文件内容)
    * [查看前面n行或者最后n行数据](#查看前面n行或者最后n行数据)
##### 查看Ubuntu版本
```
lsb_release -a
sudo lsb_release -a
```

##### 解压缩命令
```
# 压缩指定文件夹
tar cvf idea.tar.gz -C /home/hgp/workspace idea
tar -czvf postgres-idc.tar.gz postgres
# tar压缩当前目录(如果目录有空格的话，命令会执行失败)
WORKPATH=$PWD && tar -czvf $(basename `pwd`).tar.gz -C $WORKPATH $(ls $WORKPATH)
# 解压命令
tar -xvf idea.tar.gz -C /home/hgp/workspace
# 解压到指定文件夹
tar -zxvf dapeng.tar.gz -C /data/nginx/html
```

##### 安装指定版本的软件
```
apk add python2=2.7.14-r2
```

##### 查看指定端口服务的PID
```
netstat -nlp | grep :8080 | awk '{print $7}' | awk -F"/" '{ print $1 }'
```

##### 关掉指定端口的服务
```
kill -9 $(netstat -nlp | grep :8080 | awk '{print $7}' | awk -F"/" '{ print $1 }')
```

##### Linux搜索指定路径下的文件内容
```
# grep加-i参数不区分大小写
grep -rni "netty" .
grep -rn -i "netty" /opt/soft
# grep指定搜索指定的后缀名
grep -R -n -i --include="*.java" "netty" .
grep -R -n -i --include="*.java" "netty" /opt/soft
```

##### 查看前面n行或者最后n行数据
```
tail -n 1000 /aa.txt  # 打印文件最后1000行的数据
tail -n +1000 /aa.txt # 打印文件第1000行开始以后的内容
head -n 1000 /aa.txt  # 打印前1000的内容
sed -n '1000,3000p' filename  # 显示1000到300行的数据
```