## 调用lua脚本，获取uuid
> 关闭缓存
* 可以在nginx.conf http里面配置lua_code_cache off;关闭缓存，	这样调试时每次修改lua代码不需要reload nginx；但是正式环境一定记得开启缓存。

```
mkdir -p /usr/local/openresty/nginx/lua/example-0001
tee /usr/local/openresty/nginx/conf/conf.d/port-8082.conf <<-'EOF'
server {
    listen       8082;
    server_name  localhost;

   location /uuid {
        default_type text/html;
        set_by_lua_file $res /usr/local/openresty/nginx/lua/example-0001/uuid.lua;
        echo $res;
    }

    location /hello-world {
        default_type text/html;
        content_by_lua '
            ngx.say("<p>hello, world</p>")
        ';
    }
}
EOF

tee /usr/local/openresty/nginx/lua/example-0001/uuid.lua <<-'EOF'
function guid()
    local seed = {
        '0','1','2','3','4','5','6','7','8','9',
        'a','b','c','d','e','f','g','h','i','j',
        'k','l','m','n','o','p','q','r','s','t',
         'u','v','w','x','y','z'
    }
 
    local sid = ""
    for i=1, 32 do
        sid = sid .. seed[math.random(1,36)]
    end
 
    return string.format('%s-%s-%s-%s-%s',
        string.sub(sid, 1, 8),
        string.sub(sid, 9, 12),
        string.sub(sid, 13, 16),
        string.sub(sid, 17, 20),
        string.sub(sid, 21, 32)
    )
end
return guid()
EOF

/usr/local/openresty/nginx/sbin/nginx -s reload
curl localhost:8082/uuid
curl localhost:8082/hello-world

apt-get install -y apache2-utils
ab -c100 -n5000 http://localhost:8082/hello-world 

```