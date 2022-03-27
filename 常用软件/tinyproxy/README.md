### tinyproxy 正向代理（只能用做http/http代理，不能用作socks代理）

* tinyproxy软件只需2MB的内存就可以启动，超级轻量
* squid软件需要100MB的内存才能启动，香港云1G内存的轻量服务器，运行shadowsocks的docker容器后，就部署不了squid的docker容器，tinyproxy软件只需2MB的内存就可以启动

#### 安装
```
apt install -y tinyproxy

# yum install -y tinyproxy

systemctl enable tinyproxy

systemctl restart tinyproxy

# 修改配置文件 /etc/tinyproxy/tinyproxy.conf
# 修改01) Port 8888 # 修改端口号
# 修改02) 注释 Allow 的配置行，允许所有IP使用该代理
# 修改03) 把 DisableViaHeader yes 注释去掉，表示所有请求隐藏代理的请求头

systemctl restart tinyproxy

# 查看日志
tail -100f /var/log/tinyproxy/tinyproxy.log

```