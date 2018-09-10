# systemd开机服务设置参数

##### [Systemd入门教程：实战篇https://www.linuxprobe.com/systemd-bestry-artikel.html](https://www.linuxprobe.com/systemd-bestry-artikel.html)
##### [systemd添加自定义系统服务设置自定义开机启动http://www.cnblogs.com/wjb10000/p/5566801.html](http://www.cnblogs.com/wjb10000/p/5566801.html)

##### systemd有系统和用户区分；系统（/user/lib/systemd/system/）、用户（/etc/lib/systemd/user/）.一般系统管理员手工创建的单元文件建议存放在/etc/systemd/system/目录下面。
#### etcd例子
```
[Unit]
Description=etcd server
# Documentation=http://nginx.org/en/docs/
After=network.target sshd-keygen.service
After=network-online.target
Wants=network-online.target
 
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=/etc/etcd/etcd.conf
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/bin/etcd --name=\"${ETCD_NAME}\" --data-dir=\"${ETCD_DATA_DIR}\" --listen-client-urls=\"${ETCD_LISTEN_CLIENT_URLS}\" --listen-peer-urls=\"${ETCD_LISTEN_PEER_URLS}\" --advertise-client-urls=\"${ETCD_ADVERTISE_CLIENT_URLS}\" --initial-advertise-peer-urls=\"${ETCD_INITIAL_ADVERTISE_PEER_URLS}\" --initial-cluster=\"${ETCD_INITIAL_CLUSTER}\" --initial-cluster-state=\"${ETCD_INITIAL_CLUSTER_STATE}\""
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
LimitNOFILE=65536
 
[Install]
WantedBy=multi-user.target
```


#### etcd例子2
#### 在/etc/systemd/system/目录里创建etcd2.service
```
[Unit]
Description=etcd2.service

[Service]
Type=notify
TimeoutStartSec=0
Restart=always
ExecStartPre=-/bin/mkdir -p /data/etcd2
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/bin/etcd \
  --data-dir /data/etcd2 \
  --name etcd0 \
  --advertise-client-urls http://172.18.6.101:2379,http://172.18.6.101:4001 \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-advertise-peer-urls http://172.18.6.101:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster etcd0=http://172.18.6.101:2380,etcd1=http://172.18.6.102:2380,etcd2=http://172.18.6.103:2380
  
[Install]
WantedBy=multi-user.target
```
```
# 设置服务自启动
systemctl enable /etc/systemd/system/etcd2.service
# 启动etcd2
systemctl restart etcd2.service
```
