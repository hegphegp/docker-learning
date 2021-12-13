#### acme.sh自动化生成证书和续期

## 亲测能用的sh命令
```
ALL_PROXY=socks5://127.0.0.1:1082 curl https://get.acme.sh | ALL_PROXY=socks5://127.0.0.1:1082 sh
# 上面的sh脚本，会在当前用户的 ~/.bashrc 写入 ~/.acme.sh/acme.sh.env

source /etc/profile
export Ali_Key="xxxxxxxx"
export Ali_Secret="xxxxxxxxxxxxxxxxxxxx"

echo "export DOH_USE=3" >> ~/.acme.sh/acme.sh.env

# 先注册邮箱
~/.acme.sh/acme.sh --register-account -m 2386824052@qq.com

source ~/.acme.sh/acme.sh.env

## 2021-120-13~14两天亲测，默认方式无法生成证书，还各种网络访问不了，各种问题，人都被搞死，因此设置使用 --server letsencrypt 方式生成证书
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

~/.acme.sh/acme.sh --renew --force --issue --dns dns_ali -d *.codingfly.top --key-file /opt/soft/ssl/codingfly.top/privkey.key --fullchain-file /opt/soft/ssl/codingfly.top/fullchain.pem --debug

```

##### acme.sh安装，安装到~/.acme.sh目录(禁止自作聪明各种百度设置安装路径，我浪费了几个小时在上面都没找到，有多少生命是这样子被糟蹋了)
```
curl https://get.acme.sh | sh       # 会在~/.acme.sh目录安装，会在线拉取github的内容，必须保证器可以访问github，同时脚本会配置环境变量，并添加一个定时任务
source /etc/profile                 # 使环境变量重新生效

```

* 生成通配符证书，需要给dns动态添加一条记录_acme-challenge域名，本次使用阿里云账号配置appId和appAccessKey信息，让脚本实现动态添加和删除记录
* 阿里云配置AccessKey的地址 https://usercenter.console.aliyun.com/#/manage/ak 或者 https://ram.console.aliyun.com/users 或者登陆阿里云后台添加

```
source /etc/profile
export Ali_Key="账号KEY"
export Ali_Secret="账号Secret"

# acme.sh --issue --dns dns_ali -d *.domain.com # 执行完之后，会在~/.acme.sh/account.conf文件把 appId和appSecret保存下来，以后使用dns_ali时，不用配置账号密码

# 配置nginx的文件
mkdir -p /etc/nginx/conf.d
cd /etc/nginx/conf.d
tee domain.com.conf <<-'EOF'
server {
    listen       80;
    listen  443  ssl  http2;
    server_name  *.domain.com; # 通配符域名配置

    ssl_certificate /opt/soft/ssl/domain.com/fullchain.pem;
    ssl_certificate_key /opt/soft/ssl/domain.com/privkey.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
EOF


mkdir -p /opt/soft/ssl/domain.com/

acme.sh --issue --dns dns_ali -d *.domain.com --key-file /opt/soft/ssl/domain.com/privkey.key --fullchain-file /opt/soft/ssl/domain.com/fullchain.pem
# --key-file 和 --fullchain-file指定文件的生成路径，同时也会在~/.acme.sh生成所有文件
# 上面这句命令会失败很多次，因为动态添加dns记录，20秒内互联网没有这么快可以解析，要重试很多次
nginx -t
nginx -s reload

```

#### 手动续期
```
# 更新 acme.sh
acme.sh --upgrade
# 绑定提示邮箱
acme.sh --register-account -m xxxxx@qq.com
# 20210622生成的证书，curl:7.58.0-2018-01-24好像不识别https请求，搞到头炸
acme.sh --issue --dns dns_ali -d *.xxxx.top --key-file /opt/soft/ssl/xxxx.top/privkey.key --fullchain-file /opt/soft/ssl/xxxx.top/fullchain.pem --dnssleep

```