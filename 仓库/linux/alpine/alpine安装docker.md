# alpine安装docker

###### http://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/ 这个网站有alpine版本的docker下载  docker-18.03.1-r0.apk
###### http://mirrors.aliyun.com/alpine/v3.8/community/x86_64/ 这个网站有alpine版本的docker下载  docker-18.03.1-r0.apk
###### https://mirror.tuna.tsinghua.edu.cn/alpine/v3.8/community/x86_64/ 这个网站有alpine版本的docker下载  docker-18.03.1-r0.apk
###### http://mirrors.ustc.edu.cn/alpine/v3.8/community/x86_64/ 这个网站有alpine版本的docker下载  docker-18.03.1-r0.apk

###### 虚拟机安装alpine+docker环境  https://blog.csdn.net/u011411069/article/details/78546790?locationNum=9&fps=1
###### Alpine Linux配置使用技巧【一个只有5M的操作系统】 https://www.cnblogs.com/zhangmingcheng/p/7122386.html 有安装docker的例子
```
apk add docker --update-cache --repository http://mirrors.ustc.edu.cn/alpine/v3.8/main/ --allow-untrusted
```