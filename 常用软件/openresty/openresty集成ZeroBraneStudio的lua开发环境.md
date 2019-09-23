## openresty集成ZeroBraneStudio的lua开发环境

* 假设 ZeroBraneStudio 已经安装到 /opt/soft/zbstudio/ZeroBraneStudio-1.80 路径
* 假设 openresty 已经安装到 /usr/local/openresty/ 路径

#### 给 /usr/local/openresty/nginx/conf/nginx.conf 的 在http部分引入Lua库模块
```
# 在http部分引入Lua库模块
# lua模块路径，多个之间";"分隔，其中";;"表示默认搜索路径，问题, openrestry的lua默认搜索路径是 /usr/local/openresty/ 吗 ?
# lua_package_path   "/usr/local/lualib/?/?.lua;;";  # lua 模块  
# lua_package_cpath "/usr/local/lualib/?.so;;";    # c 模块  

http {
    include       mime.types;
    default_type  application/octet-stream;

    #lua_code_cache off;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

# 在http部分引入Lua库模块
# lua模块路径，多个之间";"分隔，其中";;"表示默认搜索路径，问题, openrestry的lua默认搜索路径是 /usr/local/openresty/ 吗 ?
# lua_package_path   "/usr/local/lualib/?.lua;;";  #lua 模块  
# lua_package_cpath "/usr/local/lualib/?.so;;";    #c 模块   

    lua_package_path '/opt/soft/zbstudio/ZeroBraneStudio-1.80/lualibs/?.lua;/opt/soft/zbstudio/ZeroBraneStudio-1.80/lualibs/?/?.lua;;';
    lua_package_cpath '/opt/soft/zbstudio/ZeroBraneStudio-1.80/bin/clibs/?.so;;';

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    gzip  on;

    include /usr/local/openresty/nginx/conf/conf.d/*.conf;
}


## 校验配置参数
sudo /usr/local/openresty/nginx/sbin/nginx -t

```