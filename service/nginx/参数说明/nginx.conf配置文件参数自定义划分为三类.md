### 自己划分nginx常用配置参数为三类
![avatar](../imgs/nginx.conf参数自定义划分的三部分.png)
* 最外围部分
* event部分
* http部分


##### 最外围部分常用的就4个参数
```lombok.config
user  nginx;
worker_processes  2; #设置值和CPU核心数一致
# 可以在下方直接使用 [ debug | info | notice | warn | error | crit ]  参数
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
```

##### event部分常用的就2个参数
```lombok.config
events {
    # use [ kqueue | rtsig | epoll | /dev/poll | select | poll ], 具体内容查看 http://wiki.codemongers.com/事件模型
    use epoll;
    worker_connections  1024;
}
```

##### http部分的常用参数(每个server单独写到对应的文件，禁止在nginx.conf文件里面写server的参数)
```lombok.config
http {
    include mime.types;
    default_type application/octet-stream;
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log logs/access.log main;
    sendfile on;
    # tcp_nopush on;
    # keepalive_timeout 65;

    # gzip压缩功能设置
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 6;
    gzip_types text/html text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml;
    gzip_vary on;

    # http_proxy 设置
    # 设定通过nginx上传文件的大小
    # client_max_body_size 10m;
    client_body_buffer_size 128k;
    # proxy_connect_timeout 75;
    # proxy_send_timeout 75;
    # proxy_read_timeout 75;
    proxy_buffer_size 4k;
    proxy_buffers 4 32k;
    proxy_busy_buffers_size 64k;
    proxy_temp_file_write_size 64k;
    proxy_temp_path /usr/local/nginx/proxy_temp 1 2;

    include /etc/nginx/conf.d/*.conf;

    # nginx防盗链
    # location ~* \.(gif|jpg|png|swf|flv)$ {
    #     valid_referers none blocked *.javafly.net;
    #     if ($invalid_referer) {
    #         return 404;
    #     }
    # }
}
```
