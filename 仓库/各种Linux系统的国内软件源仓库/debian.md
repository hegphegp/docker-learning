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

```
Debian 9（stretch） — 当前的稳定版
Debian 8（jessie） — 被淘汰的稳定版
Debian 7（wheezy） — 被淘汰的稳定版
Debian 6.0（squeeze） — 被淘汰的稳定版
Debian GNU/Linux 5.0（lenny） — 被淘汰的稳定版
Debian GNU/Linux 4.0（etch） — 被淘汰的稳定版
Debian GNU/Linux 3.1（sarge） — 被淘汰的稳定版
Debian GNU/Linux 3.0（woody） — 被淘汰的稳定版
Debian GNU/Linux 2.2（potato） — 被淘汰的稳定版
Debian GNU/Linux 2.1（slink） — 被淘汰的稳定版
Debian GNU/Linux 2.0（hamm） — 被淘汰的稳定版
```