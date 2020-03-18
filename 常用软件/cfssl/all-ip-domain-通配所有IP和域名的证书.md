### cfssl给nginx生成 通配所有IP和域名的证书 
```
curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/local/bin/cfssl
curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/local/bin/cfssljson
curl -L https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 > /usr/local/bin/cfssl-certinfo
chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/cfssl-certinfo
mkdir -p cfssl-gen-ca
cd cfssl-gen-ca
tee ca-csr.json <<-'EOF'
{
    "CN": "这是ca-csr.json总配置文件的 CN 的参数",  
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "这是ca-csr.json总配置文件的 C 的参数",
            "L": "这是ca-csr.json总配置文件的 L 的参数",
            "ST": "这是ca-csr.json总配置文件的 ST 的参数",
            "O": "这是ca-csr.json总配置文件的 O 的参数",
            "OU": "这是ca-csr.json总配置文件的 OU 的参数"
        }
    ]
}
EOF

# 生成CA证书和私钥，生成 ca.csr ca-key.pem ca.pem 三个文件
cfssl gencert -initca ca-csr.json | cfssljson -bare ca 

tee ca-config.json <<-'EOF'
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

tee all-ip-domain-config.json <<-'EOF'
{
    "CN": "这是all-ip-domain-config.json单独配置文件的 CN 的参数",
    "hosts": [
        "*"
    ],
    "key": {
        "algo":"rsa",
        "size":2048
    },
    "names": [
        {
            "C": "这是all-ip-domain-config.json单独配置文件的 C 的参数",
            "L": "这是all-ip-domain-config.json单独配置文件的 L 的参数",
            "ST": "这是all-ip-domain-config.json单独配置文件的 ST 的参数",
            "O": "这是all-ip-domain-config.json单独配置文件的 O 的参数",
            "OU": "这是all-ip-domain-config.json单独配置文件的 OU 的参数"
        }
    ]
}
EOF

###### 执行下面命令, 生成 all-ip-domain.csr, all-ip-domain-key.pem, all-ip-domain.pem 文件
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server all-ip-domain-config.json | cfssljson -bare all-ip-domain

docker stop nginx-ca1
docker rm nginx-ca1
docker network rm nginx-ca-network
docker network create --subnet=10.123.58.0/24 nginx-ca-network
docker run -itd --restart always --name nginx-ca1 --net nginx-ca-network --ip 10.123.58.2 nginx:1.15.4-alpine

tee default.conf <<-'EOF'
server {
    # 阿里的ant-design-pro给出的nginx静态资源部署建议 # 如果有资源，建议使用 https + http2，配合按需加载可以获得更好的体验
    listen   443  ssl  http2 default_server;
    ssl_certificate /etc/nginx/certs/all-ip-domain.pem;
    ssl_certificate_key /etc/nginx/certs/all-ip-domain-key.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF

tee default-8778.conf <<-'EOF'
server {
    listen       8778    ssl;
    ssl_certificate /etc/nginx/certs/all-ip-domain.pem;
    ssl_certificate_key /etc/nginx/certs/all-ip-domain-key.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF

docker exec -it nginx-ca1 mkdir -p /etc/nginx/certs/
# 不能连续copy
docker cp all-ip-domain.pem nginx-ca1:/etc/nginx/certs/
docker cp all-ip-domain-key.pem nginx-ca1:/etc/nginx/certs/
docker cp default.conf nginx-ca1:/etc/nginx/conf.d/
docker cp default-8778.conf nginx-ca1:/etc/nginx/conf.d/

docker restart nginx-ca1 

# 谷歌浏览器成功访问 https://10.123.58.2:8778/  ， https://10.123.58.2
```