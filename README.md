## Docker学习文档

* [简介]
    * [常用的docker容器命令](Docker常用容器命令.md)
    * [Centos常用知识](Centos常用命令.md)
    * [部署运维]
        * [部署打包](部署运维/打包/打包.md)
        * [docker-compose一键部署的脚本](部署运维/服务部署/examples/docker-compose.yml)
        * [请求IP地址](常用知识/docker/请求IP地址.md)
    * [完整系统的镜像制作](完整系统的镜像制作.md)
    * [国内软件仓库和使用方式](国内软件仓库和使用方式.md)
    * [Ubuntu的软件离线安装包](软件加速仓库/Ubuntu的软件离线安装包.md)
    * [常用软件]
        * [docker安装]
            * [Linux各种操作系统安装docker]
                * [Linux通用脚本在线安装最新版的docker](常用软件/docker,compose,swarm的安装/linux安装docker/Linux通用脚本在线安装.md)
                * [Centos7通过安装包安装18.03和18.09版本](常用软件/docker,compose,swarm的安装/linux安装docker/Centos7通过安装包安装docker.md)
                * [Ubuntu16.04通过安装包安装18.03和18.09版本](常用软件/docker,compose,swarm的安装/linux安装docker/Ubuntu通过安装包安装docker.md)
            * [批量创建虚拟机]
                * [docker-machine批量创建boot2docker虚拟机](常用软件/docker,compose,swarm的安装/docker-machine搭建swarm集群/shell/create-wms.sh)
                * [vagrant批量创建虚拟机的Vagrantfile脚本](常用软件/vagrant/multi/Vagrantfile.md)
            * [docker-swarm集群搭建]
                * [docker镜像搭建docker集群](常用软件/docker,compose,swarm的安装/docker镜像搭建docker集群/docker镜像搭建docker集群.md)
                * [docker-machine创建docker-swarm集群](常用软件/docker,compose,swarm的安装/docker-machine搭建swarm集群/docker-machine创建docker-swarm集群.md)
                * [vagrant制作docker的虚拟机模板](常用软件/vagrant/制作vagrant系统镜像/虚拟机vagrant模板的制作.md)
                * [docker-swarm集群的讲解](常用软件/docker,compose,swarm的安装/docker-swarm集群的讲解.md)
            * [搭建k3s集群]
                * [k3s单节点server](常用软件/docker,compose,swarm的安装/k3s/k3s单节点server.md)
                * [k3s单节点server多agent](常用软件/docker,compose,swarm的安装/k3s/k3s单节点server多agent.md)
                * [k3s多master节点搭建](常用软件/docker,compose,swarm的安装/k3s/k3s多master节点搭建.md)
        * [vagrant]
            * [使用说明](常用软件/vagrant/使用说明.md)
            * [常用命令](常用软件/vagrant/vagrantvagrant常用命令.md)
            * [Centos的vagrant模板的制作](常用软件/vagrant/制作vagrant系统镜像/Centos的vagrant模板的制作.md)
                * [Centos-1804可远程登录的模板](常用软件/vagrant/制作vagrant系统镜像/CentOS/CentOS-7-x86_64-Vagrant-1804_02.VirtualBox-直接粘贴就可以运行.md)
                * [Centos-1805可远程登录的模板](常用软件/vagrant/制作vagrant系统镜像/CentOS/CentOS-7-x86_64-Vagrant-1805_01.VirtualBox-直接粘贴就可以运行.md)
                * [Centos-1811可远程登录的模板](常用软件/vagrant/制作vagrant系统镜像/CentOS/CentOS-7-x86_64-Vagrant-1811_02.VirtualBox-直接粘贴就可以运行.md)
            * [Ubuntu的vagrant模板的制作](常用软件/vagrant/制作vagrant系统镜像/Ubuntu的vagrant模板的制作.md)
                * [Ubuntu-1804可远程登录的模板](常用软件/vagrant/制作vagrant系统镜像/Ubuntu/Ubuntu-18.04-bionic-server-cloudimg-amd64-vagrant-直接粘贴就可以运行.md)
                * [Ubuntu-1811可远程登录的模板](常用软件/vagrant/制作vagrant系统镜像/Ubuntu/Ubuntu-18.10-cosmic-server-cloudimg-amd64-vagrant-直接粘贴就可以运行.md)
        * [charles的https抓包](常用软件/charles/README.md)
        * [firefox和charles抓取https请求](常用软件/charles/firefox和charles抓取https请求.md)
        * [chrony时间同步工具](常用软件/chrony/chrony时间同步工具.md)
        * [calico使用命令](常用软件/calico/calico.md)
        * [node使用命令](常用软件/node/node命令.md)
        * [graalvm的docker镜像](常用软件/graalvm/graalvm.md)
        * [golang](常用软件/golang/golang.md)
        * [nginx]
            * [参数说明](常用软件/nginx/nginx配置参数.md)
            * [nginx代理访问路径的问题](常用软件/nginx/访问路径的问题.md)
            * [docker-compose创建nginx请求转发的例子](常用软件/nginx/example001/docker-compose.yml)
            * [在阿里云控制台web页面设置域名与公网IP的映射](常用软件/nginx/在阿里云控制台web页面设置域名与公网IP的映射.md)
            * [nginx负载均衡](常用软件/nginx/nginx负载均衡.md)
            * [nginx的ssh流量转发的例子](常用软件/nginx/流量转发/ssh流量转发.md)
            * [acme.sh自动化生成证书和续期](常用软件/nginx/申请证书/acme.sh申请证书.md)
            * [ssl证书申请](常用软件/nginx/申请证书/Certbot申请ssl证书.md)
            * [Cerbot申请证书实验](常用软件/nginx/申请证书/Cerbot申请证书实验.md)
        * [openresty]
            * [ubuntu安装openresty](常用软件/nginx/openresty/ubuntu安装openresty.md)
        * [keepalived]
            * [keepalived配置nginx的高可用](常用软件/keepalived/配置keepalived和nginx.md)
        * [cfssl生成证书的命令说明](常用软件/cfssl/详细说明.md)
            * [cfssl给nginx生成 通配所有IP和域名的证书 ](常用软件/cfssl/all-ip-domain-通配所有IP和域名的证书.md))
            * [添加cfssl给nginx生成自签名证书的例子](常用软件/cfssl/nginx-examples/example001/README.md)
        * [etcd命令](常用软件/etcd/etcd命令.md)
        * [draw.io镜像制作的Dockerfile文件](常用软件/draw.io/dockerfile/Dockerfile)
        * [easy-mock镜像制作的Dockerfile文件](常用软件/easy-mock/Dockerfile/Dockerfile)
        * [gopub使用命令](常用软件/gopub/README.md)
        * [etcd软件使用的命令](常用软件/etcd/etcd命令.md)
        * [shell命令行操作json的工具-jq](常用软件/shell命令行操作json的工具-jq/使用说明.md)
        * [shell命令行操作xml的工具-xmlstarlet](常用软件/shell命令行操作xml的工具-xmlstarlet)
        * [nexus3仓库的配置](仓库/搭建本地仓库/nexus3/nexus3.md)
        * [squid的配置](常用软件/squid/squid.md)
        * [brew安装软件](常用软件/brew/README.md)
        * [consul](常用软件/consul/docker-compose.yml)
        * [jhipster命令](常用软件/jhipster/jhipster命令.md)
        * [rap2接口文档](常用软件/rap2/rap2接口文档.md)
        * [tinyproxy](常用软件/tinyproxy/README.md)
        * [shadowsocks]()
            * [shadowsocks命令参数](常用软件/shadowsocks/shadowsocks.md)
            * [shadowsocks的真实示例](常用软件/shadowsocks/真实示例.md)
        * [curl工具的使用](常用软件/curl/curl使用.md)
        * [keycloak开源的单点登录系统]()
        * [centos7开启telnet远程登录](常用软件/telnet/centos7开启telnet远程登录.md)
        * [zookeeper](常用软件/zookeeper/README.md)
            * [单节点](常用软件/zookeeper/singleNode/README.md)
        * [压力测试工具]()
            * [ab压测工具](常用软件/压力测试工具/ab.md)
            * [wrk压测工具](常用软件/压力测试工具/wrk.md)
        * [ELK]
            * [elasticsearch]
                * [Elasticsearch-7.x文档基本操作(CRUD)](常用软件/elk/elasticsearch/Elasticsearch-7.x文档基本操作(CRUD).md)
                * [elasticsearch的docker部署](常用软件/elk/elasticsearch/Docker搭建命令.md)
                * [elk单实例搭建](常用软件/elk/docker-compose/docker-compose.yml)
                * [elk集群搭建](常用软件/elk/cluster/simple-cluster/docker-compose.yml)
                * [elasticsearch简介和使用](常用软件/elk/elasticsearch/README.md)
                * [elasticsearch工具](常用软件/elk/elasticsearch/elasticsearch工具.md)
    * [数据库]
        * [NOSQL]
            * [mongo]
                * [mongo常用命令](数据库/NOSQL/mongo/mongo常用命令.md)
                * [mongo备份还原](数据库/NOSQL/mongo/mongo备份还原.md)
            * [neo4j的学习](数据库/NOSQL/neo4j/neo4j学习.md)
            * [Redis]
                * [redis博客](数据库/NOSQL/redis/Redis博客.md)
                * [Redis命令](数据库/NOSQL/redis/Redis命令.md)
                * [Redis-cluster集群搭建](数据库/NOSQL/redis/redis-5.0.5创建集群/Redis-cluster集群搭建.md)
                * [Redis-trib的常用命令](数据库/NOSQL/redis/redis-4.0.9创建集群/Redis-trib的常用命令.md)
                * [Redis性能压测工具redis-benchmark](数据库/NOSQL/redis/性能压测工具redis-benchmark.md)
        * [SQL]
            * [postgresql命令](数据库/SQL/postgresql/postgresql命令.md)
            * [postgresql命令](数据库/SQL/postgresql/主从流复制/同宿主机的postgres主从容器搭建.md)
            * [postgresql可视化管理页面](数据库/SQL/postgresql/postgresql命令.md)
            * [postgresql离线安装包](数据库/SQL/postgresql/离线安装包.md)
            * [postgresql全文检索](数据库/SQL/postgresql/全文检索.md)
            * [docker-entrypoint-initdb.d的postgresql开箱即用的初始化数据库例子](数据库/SQL/postgresql/initdb/docker-compose.yml)
            * [mysql命令](数据库/SQL/mysql/mysql命令.md)
            * [mysql的多主集群Percona-XtraDB-Cluster的介绍](数据库/SQL/mysql/Percona-XtraDB-Cluster/README.md)
            * [mysql的多主集群Percona-XtraDB-Cluster的docker-compose脚本](数据库/SQL/mysql/Percona-XtraDB-Cluster/手动加入集群方式/docker-compose.yml)
            * [mysql的多主集群Percona-XtraDB-Cluster的docker搭建](数据库/SQL/mysql/Percona-XtraDB-Cluster/集群创建的命令.md)
    * [网络]
        * [ssh内网穿透]
            * [例子1](网络/ssh内网穿透/场景1/内网穿透.md)
            * [例子2](网络/ssh内网穿透/场景2/内网穿透.md)
    * [运维]
        * [ansible]
            * [ansible入门例子](运维/ansible/入门例子/README.md)
            * [ansible线上环境实战任务](运维/ansible/example01/任务.md)
        * [jenkins]
            * [jenkins的使用](运维/jenkins/使用说明.md)
    * [linux]
        * [alpine的安装](软件加速仓库/linux/alpine的安装.md)
        * [Linux磁盘挂载](常用知识/linux磁盘/linux磁盘挂载.md)
        * [Linux磁盘扩容](常用知识/linux磁盘/linux磁盘扩容.md)
    * [预留模块]
        * [大数据]
            * [docker搭建真正的Hadoop集群](预留模块/大数据/hadoop/Hadoop搭建.md)
    * [systemd开机服务设置参数](零散的笔记/systemd开机服务设置参数.md)
    * [各种Linux系统配置国内软件源加速器](https://t.goodrain.com/t/topic/236)
        * [alpine国内软件源仓库配置](软件加速仓库/各种Linux系统的国内软件源仓库/alpine.md)
        * [debian国内软件源仓库配置](软件加速仓库/各种Linux系统的国内软件源仓库/debian.md)
        * [ubuntu国内软件源仓库配置](软件加速仓库/各种Linux系统的国内软件源仓库/ubuntu.md)
    * [Ubuntu-18.04配置React-native-cli开发环境](开发环境搭建/react-native/Ubuntu搭建React-native-cli环境.md)
    * [Java常用知识](常用知识/java/Java常用知识.md)
    * [Python常用知识](开发环境搭建/python/必须掌握的.md)