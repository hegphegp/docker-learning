# debian的软件源仓库源

#### debian:9.4-slim官方源
```
cat /etc/apt/sources.list
# deb http://deb.debian.org/debian stretch main
# deb http://deb.debian.org/debian stretch-updates main
# deb http://security.debian.org/debian-security stretch/updates main
```

#### debian:9.4-slim换成阿里源
```
echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/debian/ jessie-updates main non-free contrib" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/debian/ jessie-backports main non-free contrib" >> /etc/apt/sources.list
apt-get clean all
apt-get update
```