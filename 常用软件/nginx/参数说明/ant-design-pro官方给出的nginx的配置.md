#### ant-design-pro官方给出的nginx的配置

```
server {
    listen 80;
    # gzip config
    gzip on;
    gzip_min_length 1k;
    gzip_comp_level 9;
    gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
    gzip_vary on;
    gzip_disable "MSIE [1-6]\.";

    root /usr/share/nginx/html;

    location /aaa {
        rewrite ^ $scheme://$http_host/aaa/ redirect;
    }
    
    location / {
        # 用于配合 browserHistory使用
        try_files $uri $uri/ /index.html;

        # 如果有资源，建议使用 https + http2，配合按需加载可以获得更好的体验
        # rewrite ^/(.*)$ https://preview.pro.ant.design/$1 permanent;

    }

    location /api {
        proxy_pass https://ant-design-pro.netlify.com;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   Host                 $http_host;
    }
}

server {
    # 如果有资源，建议使用 https + http2，配合按需加载可以获得更好的体验
    listen 443 ssl http2 default_server;

    # 证书的公私钥
    ssl_certificate /path/to/public.crt;
    ssl_certificate_key /path/to/private.key;

    location / {
        # 用于配合 browserHistory使用
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass https://ant-design-pro.netlify.com;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_set_header   Host                  $http_host;
        proxy_set_header   X-Real-IP         $remote_addr;
    }
}
```