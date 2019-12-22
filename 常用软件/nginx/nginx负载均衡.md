### nginx负载均衡的配置
* 用nginx的docker容器模拟多个后端服务，根据负载均衡的配置请求转发到任意一台服务器
* 指定每个nginx的docker容器的IP地址，先配置docker的网络，因为 upstream 配置要指定IP。或者在upstream文件里面配置服务的hostname，应该可以在 docker run 命令中指定容器hostname，同网段的容器应该可以解析出来，这样子应该可以不用配置指定IP地址
```
mkdir -p load-balancing
cd load-balancing
docker stop nginx10 nginx11 nginx12 nginx13 nginx14
docker rm nginx10 nginx11 nginx12 nginx13 nginx14
docker network rm nginx-load-network
docker network create --subnet=10.10.12.0/24 nginx-load-network

docker run -itd --restart always --name nginx10 --net nginx-load-network --ip 10.10.12.10 -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro nginx:1.17.6-alpine
docker run -itd --restart always --name nginx11 --net nginx-load-network --ip 10.10.12.11 -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro nginx:1.17.6-alpine
docker run -itd --restart always --name nginx12 --net nginx-load-network --ip 10.10.12.12 -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro nginx:1.17.6-alpine
docker run -itd --restart always --name nginx13 --net nginx-load-network --ip 10.10.12.13 -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro nginx:1.17.6-alpine
docker run -itd --restart always --name nginx14 --net nginx-load-network --ip 10.10.12.14 -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro nginx:1.17.6-alpine
tee default.conf <<-'EOF'
server {
    listen       80;
    server_name  localhost;

    location / {
        default_type    text/html;
        return 200 "$server_addr\n";
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}
EOF

docker cp default.conf nginx11:/etc/nginx/conf.d
docker cp default.conf nginx12:/etc/nginx/conf.d
docker cp default.conf nginx13:/etc/nginx/conf.d
docker cp default.conf nginx14:/etc/nginx/conf.d

docker restart nginx11 nginx12 nginx13 nginx14

tee default.conf <<-'EOF'
# nginx默认的负载，轮询
upstream default-load {
    server 10.10.12.11:80;
    server 10.10.12.12:80;
    server 10.10.12.13:80;
    server 10.10.12.14:80;
}

# nginx按权重负载
upstream weight-load {
    server 10.10.12.11:80 weight=1;
    server 10.10.12.12:80 weight=1;
    server 10.10.12.13:80 weight=3;
    server 10.10.12.14:80 weight=3;
}

# ip_hash（客户端ip绑定对应的服务器）
upstream ip_hash-load {
    ip_hash;
    server 10.10.12.11:80;
    server 10.10.12.12:80;
    server 10.10.12.13:80;
    server 10.10.12.14:80;
}

# least_conn（最少连接），下一个请求将被分配到活动连接数量最少的服务器；
upstream least_conn-load {
    least_conn;
    server 10.10.12.11:80;
    server 10.10.12.12:80;
    server 10.10.12.13:80;
    server 10.10.12.14:80;
}

# 综合 权重 使用
# 1、down 表示单前的server暂时不参与负载
# 2、weight 权重,默认为1。 weight越大，负载的权重就越大
# 3、max_fails 允许请求失败的次数默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误
# 4、fail_timeout max_fails次失败后，暂停的时间, 设置最大失败次数为 3，也就是最多进行 3 次尝试，且超时时间为 30秒。max_fails 的默认值为 1，fail_timeout 的默认值是 10s。
# 5、backup 备用服务器, 其它所有的非backup机器down或者忙的时候，请求backup机器。所以这台机器压力会最轻
upstream combination-load {
    server 10.10.12.11:80;
    server 10.10.12.12:80 down;
    server 10.10.12.13:80 weight=3 max_fails=3 fail_timeout=30s;
    server 10.10.12.14:80 weight=2 backup;
}

# (第三方的方案)按后端服务器的响应时间来请求分配，响应时间短的优先分配；
#upstream fair-load {
#    fair;
#    server 10.10.12.11:80;
#    server 10.10.12.12:80;
#    server 10.10.12.13:80;
#    server 10.10.12.14:80;
#}

# (第三方的方案)按访问url的hash结果来分配请求，按每个url定向到同一个后端服务器，后端服务器为缓存时比较有效；
#upstream url_hash-load {
#    server 10.0.0.7:80;
#    server 10.0.0.8:80;
#    hash $request_uri;
#    hash_method crc32;
#}

server {
    listen       80;
    server_name  localhost;

    location /default-load {
        proxy_pass http://default-load;
    }

    location /weight-load {
        proxy_pass http://weight-load;
    }

    location /ip_hash-load {
        proxy_pass http://ip_hash-load;
    }

    location /least_conn-load {
        proxy_pass http://least_conn-load;
    }

    location /combination-load {
        proxy_pass http://combination-load;
    }

#    location /fair-load {
#        proxy_pass http://fair-load;
#    }

#    location /url_hash-load {
#        proxy_pass http://url_hash-load;
#    }

    location / {
        default_type    text/html;
        return 200 "$server_addr\n";
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}
EOF
docker cp default.conf nginx10:/etc/nginx/conf.d 
docker restart nginx10


curl http://10.10.12.10/default-load
curl http://10.10.12.10/weight-load
curl http://10.10.12.10/ip_hash-load
curl http://10.10.12.10/least_conn-load
curl http://10.10.12.10/combination-load


```