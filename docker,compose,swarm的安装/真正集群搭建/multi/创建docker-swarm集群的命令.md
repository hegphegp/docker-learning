# 创建docker-swarm集群的命令

* 关闭防火墙

### 谨记
* 无论防火墙是否开启，都不需要在防火墙开放22端口，ssh登录22端口都是可以通讯的

##### 开启防火墙后却没有开放端口，映射容器端口可能会抛错
<font face="微软雅黑">docker run -itd --restart always --name redis -p 6379:6379 redis:4.0.9-alpine</font>
<font color=#ff0000 face="黑体">docker: Error response from daemon: driver failed programming external connectivity on endpoint redis (a0434cdd951209bfee416e1da2b8d0e038ab607efd4b315d43409ed523fe728e):  (iptables failed: iptables --wait -t nat -A DOCKER -p tcp -d 0/0 --dport 6379 -j DNAT --to-destination 172.17.0.2:6379 ! -i docker0: iptables: No chain/target/match by that name.(exit status 1))</font>

### 关闭防火墙或者开放2377，4789，7946端口，如果关闭防火墙，端口不需要开放
* TCP      2377 用于集群管理通信(管理节点)
* TCP/UDP  4789 用于 overlay 网络流量(所有节点)
* TCP/UDP  7946 用于节点间通信(所有节点)
* TCP      2375 docker的restful API接口(所有节点)
```
# 方法一：关闭防火墙，禁止防火墙开机启动
systemctl stop firewalld
systemctl disable firewalld

# 方法二：开启防火墙，开放这几个端口(如果要映射容器端口，运行容器的时候就要开放)，在管理节点和worker开放相应的端口
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --list-ports
firewall-cmd --zone=public --remove-port=2377/tcp --permanent
firewall-cmd --zone=public --remove-port=4789/tcp --permanent
firewall-cmd --zone=public --remove-port=4789/udp --permanent
firewall-cmd --zone=public --remove-port=7946/tcp --permanent
firewall-cmd --zone=public --remove-port=7946/udp --permanent
firewall-cmd --zone=public --remove-port=2375/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports
```

### 防火墙的内容
```
# firewall-cmd --zone=public(作用域) --add-port=80/tcp(端口和访问类型) --permanent(永久生效)
查看所有打开的端口： firewall-cmd --zone=public --list-ports
更新防火墙规则： firewall-cmd --reload
查看区域信息:  firewall-cmd --get-active-zones
查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0
拒绝所有包：firewall-cmd --panic-on
取消拒绝状态： firewall-cmd --panic-off
查看是否拒绝： firewall-cmd --query-panic

添加端口：firewall-cmd --zone=public --add-port=80/tcp --permanent (--permanent永久生效，没有此参数重启后失效)
重新载入：firewall-cmd --reload
查看：firewall-cmd --zone= public --query-port=80/tcp
删除：firewall-cmd --zone= public --remove-port=80/tcp --permanent
```