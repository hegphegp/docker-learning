# cfssl生成证书

### 介绍性的说明
```
任何虚拟机和机器都不需要安装证书软件，只需要把生成的证书放到对应虚拟机的目录就可以了

### 容器相关证书类型
##### 根据认证对象可以将证书分成三类：服务器证书server cert，客户端证书client cert，对等证书peer cert(表示既是server cert又是client cert)
client certificate： 用于服务端认证客户端,例如etcdctl、etcd proxy、fleetctl、docker客户端
server certificate: 服务端使用，客户端以此验证服务端身份,例如docker服务端、kube-apiserver
peer certificate: 双向证书，用于etcd集群成员间通信

### 在kubernetes 集群中需要的证书种类如下
etcd 节点需要标识自己服务的server cert，也需要client cert与etcd集群其他节点交互，当然可以分别指定2个证书，也可以使用一个对等证书
master 节点需要标识 apiserver服务的server cert，也需要client cert连接etcd集群，这里也使用一个对等证书
kubectl calico kube-proxy 只需要client cert，因此证书请求中 hosts 字段可以为空
kubelet证书比较特殊，不是手动生成，它由node节点TLS BootStrap向apiserver请求，由master节点的controller-manager 自动签发，包含一个client cert 和一个server cert
```

```
curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/local/bin/cfssl
curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/local/bin/cfssljson
curl -L https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 > /usr/local/bin/cfssl-certinfo
chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/cfssl-certinfo
mkdir -p cfssl-config && cd cfssl-config

cat > ca-csr.json <<EOF
{
    "CN": "kubernetes",  
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca 

cat > ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "43800h"
        },
        "profiles": {
            "server": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF

cat > kubernetes-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
        "127.0.0.1",
        "10.10.90.105",
        "10.10.90.106",
        "10.10.90.107",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [{
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "k8s",
        "OU": "System"
    }]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer kubernetes-csr.json | cfssljson -bare kubernetes

```

> 步骤二是全局配置
> 步骤三是证书生成策略配置文件，可以全局公用一个，里面配置三种类型：server, client, peer
> 步骤四以后都是配置具体的证书

### 步骤一：下载相关软件，共3个软件
```
curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/local/bin/cfssl
curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/local/bin/cfssljson
curl -L https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 > /usr/local/bin/cfssl-certinfo
chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/cfssl-certinfo
mkdir -p cfssl-config && cd cfssl-config
```

### 步骤二：创建认证中心(CA) 创建根证书
* CA证书是集群所有节点共享的，只需要创建一个 CA 证书，后续创建的所有证书都由它签名。
* CFSSL可以创建一个获取和操作证书的内部认证中心。
* 运行认证中心需要一个CA证书和相应的CA私钥。任何知道私钥的人都可以充当CA颁发证书。因此，私钥的保护至关重要。
```
cat > ca-csr.json <<EOF
{
    "CN": "kubernetes",  
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

```
> 此时该目录文件个数是 <b>1  ca-csr.json </b>

#### 生成CA证书和私钥
```
cfssl gencert -initca ca-csr.json | cfssljson -bare ca 
```
* 使用现有的CA私钥，重新生成：cfssl gencert -initca -ca-key key.pem ca-csr.json | cfssljson -bare ca
* 使用现有的CA私钥和CA证书，重新生成：cfssl gencert -renewca -ca cert.pem -ca-key key.pem
> 该命令生成3个文件：<b>ca.pem（证书）、ca.csr（证书签名请求）、ca-key.pem（私钥），其中ca-key.pem是CA私钥，需妥善保管</b>  
> 此时该目录文件个数是 <b>4  ca-csr.json ca.pem ca.csr ca-key.pem</b>  

### 步骤三：添加ca-config.json证书生成策略配置文件
> * 配置证书生成策略，让CA软件知道颁发什么样的证书  
> * ca-config.json：可以定义多个 profiles，分别指定不同的过期时间、使用场景等参数；后续在签名证书时使用某个 profile；
> * signing：表示该证书可用于签名其它证书；生成的 ca.pem 证书中 CA=TRUE；
> * server auth：服务端证书；表示client可以用该 CA 对server提供的证书进行验证；server 由服务器使用，并由客户端验证服务器身份
> * client auth：客户端证书；表示server可以用该CA对client提供的证书进行验证；client用于通过服务器验证客户端。
> * peer 对等证书；就是server auth、client auth都有的。成员之间共用，供它们彼此之间通信使用

```
cat > ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "43800h"
        },
        "profiles": {
            "server": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF

```


## 下面是具体证书的配置文件
### 步骤四：创建kubernetes证书
#### kubernetes-csr.json配置文件
```
cat > kubernetes-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
        "127.0.0.1",
        "10.10.90.105",
        "10.10.90.106",
        "10.10.90.107",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [{
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "k8s",
        "OU": "System"
    }]
}
EOF

```
#### 生成证书的命令
```
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer kubernetes-csr.json | cfssljson -bare kubernetes
```
> -config=ca-config.json 指定证书生成策略配置文件  
> -profile=peer 指定证书生成策略配置文件的profile，必须是在策略证书里面配置的