# docker-swarm配置TLS

* 设置的前提条件
* 创建一个CA服务器
* 创建并签署密钥
* 安装这个密钥
* 配置Engine daemon的TLS
* 创建Swarm集群
* 创建使用TLS的Swarm manager集群
* 测试Swarm manager的配置
* 配置Engine CLI使用TLS

## 设置的前提条件
> 为了完成这个过程你必须搭建*5*个Linux服务器