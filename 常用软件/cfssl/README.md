# cfssl生成证书
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
> 此时该目录只有 <strong><b>1</b></strong> 个文件  ca-csr.json  
> <font color=#0099ff size=60 face="黑体">color=#0099ff size=72 face="黑体"</font>
#### 生成CA证书和私钥
```
```