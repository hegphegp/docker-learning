# etcd命令.md

#### 介绍
```
Etcd本质上与一个NoSQL的数据库系统也有几分神似，但更准确的说法说是一个高可用的键值存储系统。
与一般的NoSQL数据库不同，Etcd在设计的初衷主要用于是共享配置和服务发现，它的灵感来自于ZooKeeper和Doozer。
```

#### 操作描述
```
etcd操作围绕对键值和目录的CRUD完整生命周期的管理(CRUD即Create,Read,Update,Delete，是符合REST风格的一套API操作)
etcd在键的组织上采用了层次化的空间结构(类似于目录结构)
用户指定的键可以为单独的名字，如testkey，此时实际上放在根目录/下面，
也可以为指定目录结构，如 cluster1/node2/testkey，则将创建相应的目录结构
```

#### 使用命令
```
docker run --restart always -itd --name etcd -p 2379:2379 -p 2380:2380 appcelerator/etcd:3.3
```

##### set命令:设置某个键的值
```
etcdctl set /testdir/testkey "Hello world" --ttl '0'
# 支持的选项包括：
# --ttl '0'                  该键值的超时时间（单位为秒），不配置（默认为 0）则永不超时
# --swap-with-value value    若该键现在的值是 value，则进行设置操作
# --swap-with-index '0'      若该键现在的索引值是指定索引，则进行设置操作
```

##### get命令:获取指定键的值, 当键不存在时，则会报错
```
etcdctl get /testdir/testkey
# 支持的选项包括：
# --sort          对结果进行排序
# --consistent    将请求发给主节点，保证获取内容的一致性
```

##### update命令:当键存在时，更新值内容。 当键不存在时，则会报错
```
etcdctl update /testdir/testkey "Hello"
# 支持的选项包括：
# --ttl '0'           超时时间（单位为秒），不配置（默认为 0）则永不超时
```

##### rm命令:删除某个键值。 当键不存在时，则会报错
```
etcdctl update /testdir/testkey "Hello"
# 支持的选项包括：
# --dir                如果键是个空目录或者键值对则删除
# --recursive          删除目录和所有子键
# --with-value         检查现有的值是否匹配
# --with-index '0'     检查现有的 index 是否匹配
```

##### mk命令:如果给定的键不存在，则创建一个新的键值。 当键存在时，则会报错
```
etcdctl mk /testdir/testkey "Hello world"
# 支持的选项包括：
# --ttl '0'            超时时间（单位为秒），不配置（默认为 0）则永不超时
```

##### mkdir命令:如果给定的键目录不存在，则创建一个新的键目录。 当键存在时，则会报错
```
etcdctl mkdir testdir2
# 支持的选项包括：
# --ttl '0'            超时时间（单位为秒），不配置（默认为 0）则永不超时
```

##### setdir:创建一个键目录，无论存在与否。
```
# 支持的选项包括：
# --ttl '0'            超时时间（单位为秒），不配置（默认为 0）则永不超时
```

##### updatedir:更新一个已经存在的目录
```
# 支持的选项包括：
# --ttl '0'            超时时间（单位为秒），不配置（默认为 0）则永不超时
```

##### rmdir:删除一个空目录，或者键值对。若目录不空，会报错
```
etcdctl setdir dir1
etcdctl rmdir dir1
```

##### ls:列出目录（默认为根目录）下的键或者子目录，默认不显示子目录中内容
```
etcdctl ls
etcdctl ls /dir1
# 支持的选项包括：
# --sort                将输出结果排序
# --recursive           如果目录下有子目录，则递归输出其中的内容
# -p                    对于输出为目录，在最后添加 `/` 进行区分
```

```
ETCD 命令
存储:
    curl http://127.0.0.1:4001/v2/keys/testkey -XPUT -d value='testvalue'
    curl -s http://127.0.0.1:4001/v2/keys/message2 -XPUT -d value='hello etcd' -d ttl=5
获取:
    curl http://127.0.0.1:4001/v2/keys/testkey
查看版本:
    curl  http://127.0.0.1:4001/version
删除:
    curl -s http://127.0.0.1:4001/v2/keys/testkey -XDELETE
监视:
    窗口1：curl -s http://127.0.0.1:4001/v2/keys/message2 -XPUT -d value='hello etcd 1'
          curl -s http://127.0.0.1:4001/v2/keys/message2?wait=true
    窗口2：
          curl -s http://127.0.0.1:4001/v2/keys/message2 -XPUT -d value='hello etcd 2'
自动创建key:
    curl -s http://127.0.0.1:4001/v2/keys/message3 -XPOST -d value='hello etcd 1'
    curl -s 'http://127.0.0.1:4001/v2/keys/message3?recursive=true&sorted=true'
创建目录：
    curl -s http://127.0.0.1:4001/v2/keys/message8 -XPUT -d dir=true
删除目录：
    curl -s 'http://127.0.0.1:4001/v2/keys/message7?dir=true' -XDELETE
    curl -s 'http://127.0.0.1:4001/v2/keys/message7?recursive=true' -XDELETE
查看所有key:
    curl -s http://127.0.0.1:4001/v2/keys/?recursive=true
存储数据：
    curl -s http://127.0.0.1:4001/v2/keys/file -XPUT --data-urlencode value@upfile
使用etcdctl客户端：
存储:
    etcdctl set /liuyiling/testkey "610" --ttl '100' --swap-with-value value
获取：
    etcdctl get /liuyiling/testkey
更新：
    etcdctl update /liuyiling/testkey "world" --ttl '100'
删除：
    etcdctl rm /liuyiling/testkey
目录管理：
    etcdctl mk /liuyiling/testkey "hello"    类似set,但是如果key已经存在，报错
    etcdctl mkdir /liuyiling 
    etcdctl setdir /liuyiling  
    etcdctl updatedir /liuyiling      
    etcdctl rmdir /liuyiling    
查看：
    etcdctl ls --recursive
监视：
    etcdctl watch mykey  --forever         +    etcdctl update mykey "hehe"
    #监视目录下所有节点的改变
    etcdctl exec-watch --recursive /foo -- sh -c "echo hi"
    etcdctl exec-watch mykey -- sh -c 'ls -al'    +    etcdctl update mykey "hehe"
    etcdctl member list
集群启动步骤
1.启动一个etcd，任意机器，如192.168.1.1:2379
2.curl -X PUT http://192.168.1.1:2379/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0f222/_config/size -d value=3
3.etcd -name machine1 -initial-advertise-peer-urls http://127.0.0.1:2380 -listen-peer-urls http://127.0.0.1:2380 -discovery http://192.168.1.1:2379/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0f222
4.如果是在三台不同的服务器上，则重复上面的命令3次，否则重复上面的命令1次+下面的命令2次
etcd -name machine2 -discovery http://192.168.1.1:2379/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0f222 -addr 127.0.0.1:2389 -bind-addr 127.0.0.1:2389 -peer-addr 127.0.0.1:2390 -peer-bind-addr 127.0.0.1:2390
etcd -name machine3 -discovery http://192.168.1.1:2379/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0f222 -addr 127.0.0.1:2409 -bind-addr 127.0.0.1:2409 -peer-addr 127.0.0.1:2490 -peer-bind-addr 127.0.0.1:2490
5.curl -L http://localhost:2379/v2/members | python -m json.tool

```


### 非数据库操作
```
# backup : 备份etcd的数据命令
# 支持的选项包括
# --data-dir         etcd 的数据目录
# --backup-dir       备份到指定路径

# watch : 监测一个键值的变化，一旦键值发生更新，就会输出最新的值并退出。例如，用户更新 testkey 键值为 Hello watch。
etcdctl get /testdir/testkey
etcdctl set /testdir/testkey "Hello watch"
etcdctl watch testdir/testkey
# 支持的选项包括
# --forever            一直监测，直到用户按 `CTRL+C` 退出
# --after-index '0'    在指定 index 之前一直监测
# --recursive          返回所有的键值和子键值

# exec-watch : 监测一个键值的变化，一旦键值发生更新，就执行给定命令。例如，用户更新 testkey 键值。
etcdctl exec-watch testkey -- sh -c 'ls'
default.etcd
Documentation
etcd
etcdctl
etcd-migrate
README-etcdctl.md
README.md
# 支持的选项包括
# --after-index '0'    在指定 index 之前一直监测
# --recursive          返回所有的键值和子键值

# member : 通过 list、add、remove 命令列出、添加、删除 etcd 实例到 etcd 集群中。例如本地启动一个 etcd 服务实例后，可以用如下命令进行查看。
etcdctl member list
# 命令选项
# --debug 输出 cURL 命令，显示执行命令的时候发起的请求
# --no-sync 发出请求之前不同步集群信息
# --output, -o 'simple' 输出内容的格式 (simple 为原始信息，json 为进行json格式解码，易读性好一些)
# --peers, -C 指定集群中的同伴信息，用逗号隔开 (默认为: "127.0.0.1:4001")
# --cert-file HTTPS 下客户端使用的 SSL 证书文件
# --key-file HTTPS 下客户端使用的 SSL 密钥文件
# --ca-file 服务端使用 HTTPS 时，使用 CA 文件进行验证
# --help, -h 显示帮助命令信息
# --version, -v 打印版本信息
```