# Linux通用脚本在线安装

##### 阿里云在线安装脚本
```
# 在2018-08-15-1709时测试阿里在线安装脚本，发现有严重问题，阿里云私自更换了下载地址，导致原地址的docker路径不存在
# curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh
```

##### 国内daocloud在线安装脚本
```
curl -sSL https://get.daocloud.io/docker | sh
```

##### 官方脚本在线安装
```
curl -sSL https://get.docker.com/ | sh
```


##### 阿里云在线安装docker-compose
```
curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# curl -L https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# mirrors.aliyun.com的docker-compose版本落后 https://github.com/docker/compose/releases 了两年
# ALL_PROXY=socks5://127.0.0.1:1080 curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

##### 阿里云在线安装docker-machine
```
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/machine/0.15.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-machine
```