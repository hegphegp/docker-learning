local redis = require "redis_iresty"
local red = redis:new({host="192.168.3.2", port=6379, password="admin", db_index=0})

local uid, err = red:get("dog")
if not uid then
    ngx.status = ngx.HTTP_FORBIDDEN --返回错误码
    ngx.say("{\"code\":401,\"msg\":\"no login\"}")  --返回错误消息
    ngx.exit(200) -- 跟以上两个连用,固定写法
else
    ngx.req.set_header("userId", uid)
--    ngx.var.uid = uid; -- ngx.var.uid = uid; 性能低到无法忍受, ngx.var.uid = uid 的qps 只有 ngx.req.set_header("userId", uid) 的1/3, 在高并发下, 可能是 1/20
end

