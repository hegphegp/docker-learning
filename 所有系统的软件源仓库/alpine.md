# apline软件源仓库源

### 百度关键字： "Alpine Linux 镜像源使用帮助"或者"修改软件源为国内加速镜像"

##### alpine3.4版本
```
cp /etc/apk/repositories /etc/apk/repositories-back
echo "http://mirrors.aliyun.com/alpine/v3.4/main" > /etc/apk/repositories
echo "http://mirrors.aliyun.com/alpine/v3.4/community" >> /etc/apk/repositories
cat /etc/apk/repositories-back >> /etc/apk/repositories
apk update
```

##### alpine3.7版本
```
cp /etc/apk/repositories /etc/apk/repositories-back
echo "http://mirrors.aliyun.com/alpine/v3.7/main" > /etc/apk/repositories
echo "http://mirrors.aliyun.com/alpine/v3.7/community" >> /etc/apk/repositories
cat /etc/apk/repositories-back >> /etc/apk/repositories
apk update
```

##### 安装软件
```
apk add --no-cache curl
```

##### 查看系统版本号
```
cat /etc/issue
cat /proc/version
uname -a
```