> 查看docker进程日志    journalctl -fu docker.service
> 查看docker进程日志    systemctl status docker

* 在配置/usr/lib/systemd/system/docker.service的参数时，通用的配置方法是：在EnvironmentFile的参数配置/etc/sysconfig/docker（基本配置）、/etc/sysconfig/docker-storage（存储）、/etc/sysconfig/docker-network（网络），我们想要/etc/default/docker 生效，就需要添加EnvironmentFile=-/etc/default/docker，让后在ExecStart这个配置中，添加引用的参数$DOCKER_OPTS
* 默认情况下，/etc/default/docker配置了不会生效的，我们需要手动添加到docker的环境设定中，需要配置的文件是/usr/lib/systemd/system/docker.service，需要添加EnvironmentFile=-/etc/default/docker，让后在ExecStart这个配置中，添加引用的参数$DOCKER_OPTS。

##### 下面就是/etc/sysconfig/docker配置文件
```
DOCKER_OPTS="$DOCKER_OPTS --label com.example.environment='production' "
```

##### 下面就是/usr/lib/systemd/system/docker.service配置文件
```
Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target
Wants=docker-storage-setup.service
Requires=docker-cleanup.timer
 
[Service]
Type=notify
NotifyAccess=all
KillMode=process
#添加我们自定义的配置文件
EnvironmentFile=-/etc/sysconfig/docker
EnvironmentFile=-/etc/sysconfig/docker-storage
EnvironmentFile=-/etc/sysconfig/docker-network
Environment=GOTRACEBACK=crash
Environment=DOCKER_HTTP_HOST_COMPAT=1
Environment=PATH=/usr/libexec/docker:/usr/bin:/usr/sbin
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock \
          $OPTIONS \
          $DOCKER_STORAGE_OPTIONS \
          $DOCKER_NETWORK_OPTIONS \
          $DOCKER_OPTS #需要引用的参数，也是网卡设定参数
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
Restart=on-abnormal
MountFlags=slave
 
[Install]
WantedBy=multi-user.target
EnvironmentFile=-/etc/default/docker
```

##### docker swarm限制服务所在机器的方法
###### 方法一：通过  --label 和宿主机的DOCKER_OPTS参数 配置所在的服务器
* 下面就是/etc/sysconfig/docker配置文件
```
DOCKER_OPTS="$DOCKER_OPTS --label com.example.environment='production' "
```
* 在 com.example.environment="production" 和 com.example.storage="ssd"的DOCKER_OPTS对应的服务器创建服务
```
docker service creaate ... \
  --label com.example.environment="production" \
  --label com.example.storage="ssd"
```

* docker-compose的例子， 限制在 标记为 com.example.storage="ssd" 的宿主上创建服务
```
version: "2"
services:
  mongodb:
    image: mongo:latest
    environment:
      - "constraint:com.example.storage==ssd"
```

* 通过  --constraint 限制， 通过 node.hostname 限制
```
docker service create --name xxx --constraint engine.labels.com.example.environment==production xxx
docker service create --name xxx --constraint node.hostname==swarm1 xxx
```