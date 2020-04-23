### yum和apt-get在线安装nginx最新的版本

* 之前一直不知道nginx有个比较新的yum源和apt-get源, 导致yum和apt-get安装的是低版本

#### Centos7安装最新的nginx版本
```
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install -y nginx
```

#### Ubuntu通过apt-get安装最新的nginx版本
```
mkdir -p /etc/apt/sources.list.d
# 我通过 https://nginx.org/packages/ubuntu/ 这个URL, 手写了nginx的apt-get源的文件 /etc/apt/sources.list.d/nginx.list
echo "deb https://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list
echo "deb-src https://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" >> /etc/apt/sources.list.d/nginx.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
apt-get update
apt-get install -y nginx
```


#### nginx在配置文件中设置日志按年、月、日、时分割日志, 不借助logrotate工具或配置cron任务
* 必须要保证/etc/nginx/nginx.conf的user用户, 在日志目录有创建文件的权限, 否则无法在该目录创建日志
* 在conf.d每个单独的配置文件做日志
```
server {
    listen       80;
    server_name  localhost;

    if ($time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})") {
        set $year $1;
        set $month $2;
        set $day $3;
#        set $hour $4;
#        set $minutes $5;
#        set $seconds $6;
    }

#    access_log /var/log/nginx/domain1/api-access-$year-$month-$day-$hour-$minutes-$seconds.log main;
#    error_log /var/log/nginx/domain1/api-error.log;

    access_log /var/log/nginx/domain1/access-$year-$month-$day.log main;
    error_log /var/log/nginx/domain1/error-$year-$month.log;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

}
```

* 在nginx.conf总的配置文件做日志
```
user  root;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_iso8601] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    if ($time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})") {
        set $year $1;
        set $month $2;
        set $day $3;
#        set $hour $4;
#        set $minutes $5;
#        set $seconds $6;
    }

#    access_log /var/log/nginx/domain1/api-access-$year-$month-$day-$hour-$minutes-$seconds.log main;
#    error_log /var/log/nginx/domain1/api-error.log;

    access_log /var/log/nginx/domain1/access-$year-$month-$day.log main;
    error_log /var/log/nginx/domain1/error-$year-$month.log;


    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}

```