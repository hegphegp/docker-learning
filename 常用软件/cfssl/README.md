# cfssl生成证书

> 步骤二是全局配置
> 步骤三是证书生成策略配置文件，可以全局公用一个，里面配置三种类型：server, client, peer
> 步骤四以后都是配置具体的证书  

### 容器相关证书类型
* client certificate： 用于服务端认证客户端,例如etcdctl、etcd proxy、fleetctl、docker客户端
* server certificate: 服务端使用，客户端以此验证服务端身份,例如docker服务端、kube-apiserver
* peer certificate: 双向证书，用于etcd集群成员间通信

### 步骤一：下载相关软件，共3个软件
```
curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/local/bin/cfssl
curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/local/bin/cfssljson
curl -L https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 > /usr/local/bin/cfssl-certinfo
chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/cfssl-certinfo
# chmod +x /usr/local/bin/cfssl
# chmod +x /usr/local/bin/cfssljson
# chmod +x /usr/local/bin/cfssl-certinfo

# 创建生成证书的配置目录
cfssl_config_path=cfssl-`date '+%Y%m%d-%H%M%S'`
mkdir -p $cfssl_config_path
cd $cfssl_config_path

```

### 步骤二：添加ca-csr.json配置文件，然后生成CA证书和私钥
#### 添加ca-csr.json配置文件(其实可以用 cfssl print-defaults csr > ca-csr.json 命令生成模板，然后修改，还不如把修改后的文件一步生成)
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