# Certbot申请ssl证书

* 好无奈的现实，发现低版本v0.26.1的certbot的 --dry-run 参数不能用，导致做不了自动化，本身对certbot就不熟，出错后完全不知道怎么搞
```
# 在 2018年6月份的时候，certbot/certbot:v0.26.1 版本可以加 --dry-run 参数
# 但是到了 2020年01月28号时，再用该版本 certbot/certbot:v0.26.1 加 --dry-run 参数，出错了 An unexpected error occurred: The request message was malformed :: Method not allowed
# 此时用 certbot/certbot:v0.37.2 版本加 --dry-run 参数，却不抛错
```

* 上次折腾时，Let's Encrypt 还叫 Let's Encrypt，现在已经改名为 Certbot 了
* 配置 email 的用处是：Let's Encrypt 证书有效期是 90 天，Let's Encrypt 会在证书快过期的时候，发送邮件通知。

### Certbot申请SSL证书时，一定先要加 --dry-run 参数，避免遇到操作次数的限制
* 使用 --standalone 方式, 需要占用 443端口, 所以先把443端口的服务停止

### 真正可以直接运行生成证书的命令
```
docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone -n --agree-tos --register-unsafely-without-email --server https://acme-v02.api.letsencrypt.org/directory -d aaa.javafly.net
```

###### 生成单个证书
```
mkdir -p /etc/letsencrypt
docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone -n --agree-tos --register-unsafely-without-email --server https://acme-v02.api.letsencrypt.org/directory -d aaa.javafly.net

# 证书续期的测试命令
docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 renew --dry-run

# 证书续期的命令
docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 renew

docker run -itd --restart always --name nginx -e TZ=Asia/Shanghai -p 80:80 -p 443:443 -v /etc/localtime:/etc/localtime:ro -v /etc/letsencrypt:/etc/letsencrypt nginx:1.15.4-alpine

# 不能连续copy,否则会翻车

tee aaa.javafly.net.conf <<-'EOF'
server {
      listen       80;
      listen       443 ssl;
      server_name  aaa.javafly.net;

      ssl_certificate /etc/letsencrypt/live/aaa.javafly.net/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/aaa.javafly.net/privkey.pem;
      ssl_trusted_certificate /etc/letsencrypt/live/aaa.javafly.net/chain.pem;

      location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
      }
}
EOF
docker cp aaa.javafly.net.conf nginx:/etc/nginx/conf.d
docker restart nginx
 # 然后通过域名访问根路径  https://aaa.javafly.net
```

###### 生成多个证书，用certbot/certbot:v0.37.2亲测，发现只生成
```
mkdir -p /etc/letsencrypt
docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone -n --agree-tos --register-unsafely-without-email --server https://acme-v02.api.letsencrypt.org/directory -d aaa.javafly.net -d bbb.javafly.net -d ccc.javafly.net --dry-run

docker run -itd --restart always --name nginx -e TZ=Asia/Shanghai -p 80:80 -p 443:443 -v /etc/localtime:/etc/localtime:ro -v /etc/letsencrypt:/etc/letsencrypt nginx:1.15.4-alpine

# 不能连续copy,否则会翻车

tee aaa.javafly.net.conf <<-'EOF'
server {
      listen       80;
      listen       443 ssl;
      server_name  aaa.javafly.net;

      ssl_certificate /etc/letsencrypt/live/aaa.javafly.net/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/aaa.javafly.net/privkey.pem;
      ssl_trusted_certificate /etc/letsencrypt/live/aaa.javafly.net/chain.pem;

      location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
      }
}
EOF
cp aaa.javafly.net.conf  bbb.javafly.net.conf
cp aaa.javafly.net.conf  ccc.javafly.net.conf
sed -i 's|aaa.javafly.net|bbb.javafly.net|g' bbb.javafly.net.conf
sed -i 's|aaa.javafly.net|ccc.javafly.net|g' ccc.javafly.net.conf
docker cp aaa.javafly.net.conf nginx:/etc/nginx/conf.d
docker cp bbb.javafly.net.conf nginx:/etc/nginx/conf.d
docker cp ccc.javafly.net.conf nginx:/etc/nginx/conf.d
docker restart nginx
# 然后通过域名访问根路径  https://aaa.javafly.net   https://bbb.javafly.net    https://ccc.javafly.net 
```

* 使用 --dry-run 参数 不会生成 /etc/letsencrypt/live/域名/fullchain.pem , /etc/letsencrypt/live/域名/privkey.pem , /etc/letsencrypt/live/域名/chain.pem 这些文件

##### cerbot命令的参数说明
* certonly 表示安装模式，Certbot 有安装模式和验证模式两种类型的插件。
* --manual 表示手动安装插件，Certbot 有很多插件，不同的插件都可以申请证书，用户可以根据需要自行选择, 不要加这个参数, 因为自己不知道有什么插件
* -d 为那些主机申请证书，如果是通配符，输入 *.xxxx.com (可以替换为你自己的域名)
* --email 指定邮箱, 如果不想写邮箱, 可以使用 --register-unsafely-without-email 参数，配置 email 的用处是：Let's Encrypt 会在证书快过期的时候，发送邮件通知
* -n 非交互式，因此 -n 与 --agree-tos 必须一起用
* --agree-tos 同意服务协议
* --server，Let’s Encrypt ACME v2 版本使用的服务器不同于 v1 版本，需要显式指定，v2版本生成的证书目录和v1版本完全不同，v2不往前兼容v1版本的证书，配符数字证书的 ACME V2 版 API 

```
server {
    listen       80;
    listen       443 ssl;
    server_name  aaa.javafly.net;

    ssl_certificate /etc/letsencrypt/live/aaa.javafly.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/aaa.javafly.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/aaa.javafly.net/chain.pem;

    client_max_body_size 100M;

    location / {
        proxy_set_header Host                 $host:$server_port;
        proxy_set_header X-Real-IP            $remote_addr;
        proxy_set_header X-Forwarded-For      $proxy_add_x_forwarded_for;
        proxy_set_header HTTP_X_FORWARDED_FOR $remote_addr;
        proxy_set_header X-Forwarded-Proto    $scheme;
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

## 因为自己是菜鸡, 搞不懂下面参数的含义, 生成证书时绝对不可以加下面参数, 加了, 害死自己怨不了人
* --preferred-challenges dns，使用 DNS 方式校验域名所有权 , 加了该参数 , 发现没有生成 /etc/letsencrypt/live/域名/fullchain.pem , /etc/letsencrypt/live/域名/privkey.pem , /etc/letsencrypt/live/域名/chain.pem 这些文件, 整个人都懵逼了


##### 下面的内容可以忽略, 下面的说明可能是错的, 因为笔者能力有限, 网上也没有博客详细介绍那个参数是什么意思, 网上的大牛也没有一边敲命令一边测试每个参数的截图
##### Certbot生成证书的两种方式，一种方式是命令包含--webroot参数的，另外一种方式是命令包含--standalone参数的
* 命令带--webroot参数的方式(不占用443端口进行校验吗,--standalone参数方式会使用443端口进行验证)
```
certbot certonly --webroot -w /var/www/example -d example.com -d www.example.com
```
- 这条命令的意思是为 以/var/www/example为根目录 的两个域名example.com和www.example.com申请证书

* 命令带--standalone参数的方式(常用的方式，当内网的服务器无法被letsencrypt的服务器访问到时，当不知道网站的根目录在哪里或者是网站根目录不在当前机器时)
> * 如果网站没有根目录或者是你不知道你的网站根目录在哪里，可以通过下面的语句来实现
```
certbot certonly --standalone -d example.com -d www.example.com --dry-run
# certbot certonly --standalone --email xxxx.qq.com -d 域名1 -d 域名2  --dry-run
# certbot certonly --standalone -d aaa.javafly.net --register-unsafely-without-email  --dry-run
```
- 使用这条命令时，Certbot会使用443端口来进行验证，如果443端口被占用了，就必须先停止443端口的服务，然后再运行命令。证书申请完，Certbot会告诉你证书所在的目录，一般来说会在/etc/letsencrypt/live/目录

##### cerbot命令的参数说明
* certonly 表示安装模式，Certbot 有安装模式和验证模式两种类型的插件。
* --manual 表示手动安装插件，Certbot 有很多插件，不同的插件都可以申请证书，用户可以根据需要自行选择
* -d 为那些主机申请证书，如果是通配符，输入 *.xxxx.com (可以替换为你自己的域名)
* --email 指定邮箱, 如果不想写邮箱, 可以使用 --register-unsafely-without-email 参数
* -n 非交互式，因此 -n 与 --agree-tos 必须一起用
* --agree-tos 同意服务协议
* --server，Let’s Encrypt ACME v2 版本使用的服务器不同于 v1 版本，需要显式指定，v2版本生成的证书目录和v1版本完全不同，v2不往前兼容v1版本的证书，配符数字证书的 ACME V2 版 API 

##### Certbot的两种工作方式介绍
```
01) standalone 方式： certbot 会自己运行一个 web server 来进行验证。如果我们自己的服务器的443端口已经有 web server 正在运行(比如 Nginx 或 Apache)，用 standalone 方式的话需要先关掉它，以免冲突。
02) webroot 方式： certbot 会利用既有的 web server，在其 web root目录下创建隐藏文件， Let’s Encrypt 服务端会通过域名来访问这些隐藏文件，以确认你的确拥有对应域名的控制权。
```

#### 通过certbot/certbot的docker镜像生成证书
* 先生成一个文件夹 /etc/letsencrypt
* certbot/certbot的官方dockerfile文件的ENTRYPOINT已经写死了容器的运行命令，不能在cmd后面接sh命令
```
mkdir -p /etc/letsencrypt
# docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone --register-unsafely-without-email -d aaa.javafly.net --dry-run

# 添加 --agree-tos 和 -n 非交互式
docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone -n --agree-tos -d aaa.javafly.net --register-unsafely-without-email --dry-run

# Let’s Encrypt ACME v2 版本需要显式指定--server参数，且生成的证书目录结构与v1版本不同
# docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone --register-unsafely-without-email --server https://acme-v02.api.letsencrypt.org/directory -d aaa.javafly.net --dry-run

# docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone --register-unsafely-without-email --server https://acme-v02.api.letsencrypt.org/directory -d aaa.javafly.net  --dry-run

docker run -it --rm -p 443:443 -p 80:80 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot:v0.37.2 certonly --standalone -n --agree-tos --register-unsafely-without-email --server https://acme-v02.api.letsencrypt.org/directory -d aaa.javafly.net --dry-run
```


```
server {
    listen       80;
    listen       443 ssl;
    server_name  aaa.javafly.net;

    ssl_certificate /etc/letsencrypt/live/aaa.javafly.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/aaa.javafly.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/aaa.javafly.net/chain.pem;

    client_max_body_size 100M;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```