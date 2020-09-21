### 搭建Ubuntu的apt源
* 使用apt-get download下载离线安装包，使用apt-cache depends解析所有依赖包，然后使用dekg-packages制作总配置文件，使用nginx搭建安装包仓库
```
docker pull registry.cn-hangzhou.aliyuncs.com/hegp/ubuntu:20.04.1-20200729
docker tag registry.cn-hangzhou.aliyuncs.com/hegp/ubuntu:20.04.1-20200729 ubuntu:20.04.1-20200729
docker rmi registry.cn-hangzhou.aliyuncs.com/hegp/ubuntu:20.04.1-20200729
# docker run --privileged -itd --restart always -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name ubuntu ubuntu:20.04.1-20200729 /sbin/init


docker pull registry.cn-hangzhou.aliyuncs.com/hegp/ubuntu:18.04.5-20200807
docker tag registry.cn-hangzhou.aliyuncs.com/hegp/ubuntu:18.04.5-20200807 ubuntu:18.04.5-20200807
docker rmi registry.cn-hangzhou.aliyuncs.com/hegp/ubuntu:18.04.5-20200807
# docker run --privileged -itd --restart always -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name ubuntu ubuntu:18.04.5-20200807 /sbin/init

```

* 创建目录，运行容器
```
mkdir -p /opt/soft/repository/ubuntu/packages
docker run --privileged -itd --restart always -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /opt/soft/repository/ubuntu:/repository --name ubuntu-20 ubuntu:20.04.1-20200729 /sbin/init
docker run --privileged -itd --restart always -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /opt/soft/repository/ubuntu:/repository --name ubuntu-18 ubuntu:18.04.5-20200807 /sbin/init
```

* 下载nginx软件离线安装包
```
docker exec -it ubuntu-18 bash
mkdir -p /etc/apt/sources.list.d
echo "deb [trusted=yes] https://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list
echo "deb-src [trusted=yes] https://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" >> /etc/apt/sources.list.d/nginx.list
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
apt-get update
apt-cache madison nginx
# 列出nginx的版本
# root@c38344158abc:/# apt-cache madison nginx
#      nginx | 1.18.0-1~bionic | https://nginx.org/packages/ubuntu bionic/nginx amd64 Packages
#      nginx | 1.16.1-1~bionic | https://nginx.org/packages/ubuntu bionic/nginx amd64 Packages
#      nginx | 1.16.0-1~bionic | https://nginx.org/packages/ubuntu bionic/nginx amd64 Packages
cd /repository/packages/
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.18.0-1~bionic | grep "^\w")
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.16.1-1~bionic | grep "^\w")
exit

# 使用ubuntu-20下载
docker exec -it ubuntu-20 bash
mkdir -p /etc/apt/sources.list.d
echo "deb [trusted=yes] https://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list
echo "deb-src [trusted=yes] https://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" >> /etc/apt/sources.list.d/nginx.list
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
apt-get update
apt-cache madison nginx
cd /repository/packages/
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.18.0-1~focal | grep "^\w")
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.18.0-0ubuntu1 | grep "^\w")
```


### postgresql安装包，阿里云只有postgresql-12最新版本的
```
# echo "deb [trusted=yes] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# apt-get -o Acquire::sock5::proxy="socks5://192.168.1.108:1082/" update
apt-cache madison postgresql
# root@ebf89fad0aed:/repository/packages# apt-cache madison postgresql
# postgresql | 12+214ubuntu0.1 | http://mirrors.aliyun.com/ubuntu focal-security/main amd64 Packages
# postgresql | 12+214ubuntu0.1 | http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 Packages
# postgresql |     12+214 | http://mirrors.aliyun.com/ubuntu focal/main amd64 Packages
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql=12+216.pgdg20.04+1 | grep "^\w")
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql=12+214ubuntu0.1 | grep "^\w")
apt-cache madison postgresql-11
apt-cache madison postgresql-10
apt-cache madison postgresql-9.6
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql=12+214ubuntu0.1 | grep "^\w")
```

# 下载postgres-citus软件离线安装包，使用代理下载
```
docker exec -it ubuntu-18 bash
cd /repository/packages/
ALL_PROXY=socks5://192.168.1.108:1082 curl https://install.citusdata.com/community/deb.sh > deb.sh
chmod a+x deb.sh
ALL_PROXY=socks5://192.168.1.108:1082 bash deb.sh
rm -rf deb.sh
apt-cache madison postgresql-12-citus-9.4
apt-cache madison postgresql-11-citus-9.4

# apt-get -o Acquire::sock5::proxy="socks5://192.168.1.108:1082/" download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql-12-citus-9.4=9.4.0.citus-1 | grep "^\w")
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql-12-citus-9.4=9.4.0.citus-1 | grep "^\w")
# apt-get -o Acquire::sock5::proxy="socks5://192.168.1.108:1082/" download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql-11-citus-9.4=9.4.0.citus-1 | grep "^\w")
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql-11-citus-9.4=9.4.0.citus-1 | grep "^\w")

apt-cache madison postgresql-12-citus-9.3
apt-cache madison postgresql-11-citus-9.3

apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql-12-citus-9.3=9.3.5.citus-1 | grep "^\w")
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances postgresql-11-citus-9.3=9.3.5.citus-1 | grep "^\w")


```