# Linux通用脚本在线安装

##### 阿里云在线安装脚本
```
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh
```

##### 国内daocloud在线安装脚本
```
curl -sSL https://get.daocloud.io/docker | sh
```

##### 官方脚本在线安装
```
curl -sSL https://get.daocloud.io/docker | sh
```

##### 阿里云在线安装docker-compose
```
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/compose/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

##### 阿里云在线安装docker-machine
```
curl -L https://mirrors.aliyun.com/docker-toolbox/linux/machine/0.15.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-machine
```