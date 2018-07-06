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
# apk add asterisk=1.6.0.21-r0    #安装指定版本的软件
# apk add 'asterisk<1.6.1'        #安装指定版本的软件
# apk add 'asterisk>1.6.1'        #安装指定版本的软件
# apk update                      #更新最新本地镜像源 
# apk upgrade                     #升级软件
# apk add --upgrade busybox       #指定升级部分软件包
# apk search                      #查找所以可用软件包 
# apk search -v                   #查找所以可用软件包及其描述内容 
# apk search -v 'acf*'            #通过软件包名称查找软件包 
# apk search -v -d 'docker'       #通过描述文件查找特定的软件包 
# apk info                        #列出所有已安装的软件包 
# apk info -a zlib                #显示完整的软件包信息 
# apk info --who-owns /sbin/lbu   #显示指定文件属于的包 
```

##### alpine3.7管理服务的工具是 openrc
```
apk add openrc
# 设置开机启动
rc-update add 服务名 boot
```

##### 查看系统版本号
```
cat /etc/issue
cat /proc/version
uname -a
```