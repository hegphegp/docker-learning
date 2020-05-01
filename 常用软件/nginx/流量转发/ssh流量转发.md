### ssh流量转发.md

```
mkdir -p ssh-nginx
tee ssh-nginx/nginx.conf <<-'EOF'

user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;

events {
    worker_connections  1024;
}

stream {
    log_format proxy '$remote_addr [$time_local] '
                     '$protocol $status $bytes_sent $bytes_received '
                     '$session_time "$upstream_addr" '
                     '"$upstream_bytes_sent" "$upstream_bytes_received" "$upstream_connect_time"';

    access_log /var/log/nginx/access.log proxy;
    open_log_file_cache off;

    upstream ssh {
        server 192.168.35.11:22;
    }

    server { 
        listen 80;
        listen 80 udp;
        proxy_pass ssh;
        proxy_connect_timeout 1h;
        proxy_timeout 1h;
    }
}

EOF

docker run -itd --restart always --name ssh-nginx -p 35753:80 -p 35753:80/udp -v `pwd`/ssh-nginx/nginx.conf:/etc/nginx/nginx.conf nginx:1.17.6-alpine

```