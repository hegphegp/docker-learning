### 服务端
```
docker run --restart always -itd --name ssserver -p 6443:6443 -p 6500:6500/udp mritd/shadowsocks:3.2.3 -m "ss-server" -s "-s 0.0.0.0 -p 6443 -m aes-256-cfb -k shadowsocks654321 --fast-open" -x -e 
"kcpserver" -k "-t 127.0.0.1:6443 -l :6500 -mode fast2"
```
### 客户端
```
# docker run --restart always -itd --name ssclient -p 1080:1080 mritd/shadowsocks:3.2.3 -m "ss-local" -s "-s 127.0.0.1 -p 6500 -b 0.0.0.0 -l 1080 -m aes-256-cfb -k shadowsocks654321 --fast-open" -x -e "kcpclient" -k "-r 服务器IP:6500 -l :6500 -mode fast2"
docker run --restart always -itd --name ssclient -p 1080:1080 mritd/shadowsocks:3.2.3 -m "ss-local" -s "-s 127.0.0.1 -p 6500 -b 0.0.0.0 -l 1080 -m aes-256-cfb -k shadowsocks654321 --fast-open" -x -e "kcpclient" -k "-r 66.42.110.112:6500 -l :6500 -mode fast2"
```
#### 客户端下载地址 https://github.com/shadowsocks/shadowsocks-windows/releases
