## ubuntu安装openresty,  apt-get -y install openresty 安装openresty到 /usr/local/openresty 路径
```
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update && apt-get clean && apt-get autoclean && apt-get clean && apt-get autoremove

# 安装导入 GPG 公钥时所需的几个依赖包（整个安装过程完成后可以随时删除它们）：
sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates

# 导入我们的 GPG 密钥：
wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -

# 安装 add-apt-repository 命令 （之后你可以删除这个包以及对应的关联包）
sudo apt-get -y install --no-install-recommends software-properties-common

# 添加我们官方 official APT 仓库：
sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"

sudo apt-get update
sudo apt-get -y install openresty
```

## openresty重启, 启动, 关闭 命令
```
# 启动
/usr/local/openresty/nginx/sbin/nginx
# 检验nginx配置是否正确
/usr/local/openresty/nginx/sbin/nginx -t
# 停止
/usr/local/openresty/nginx/sbin/nginx -s stop
# 重启
/usr/local/openresty/nginx/sbin/nginx -s reload
# 查看日志
tail -n 100 -f /usr/local/openresty/nginx/logs/access.log
```

## openresty 的总配置文件在 /usr/local/openresty/nginx/conf/nginx.conf
* 设置nginx每个单独的conf配置文件在 /usr/local/openresty/nginx/conf/conf.d 路径
* mkdir -p /usr/local/openresty/nginx/conf/conf.d
* 创建单独的conf文件
```
tee /usr/local/openresty/nginx/conf/conf.d/port-8081.conf <<-'EOF'
server {
    listen       8081;
    server_name  localhost;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    location / {
        root   html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

}
EOF

tee /usr/local/openresty/nginx/conf/conf.d/port-8082.conf <<-'EOF'
server {
    listen       8082;
    server_name  localhost;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    location / {
        root   html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

}
EOF

```

/usr/local/openresty/nginx/nginx -t