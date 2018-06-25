## easy-mock使用.md

#### 很无奈的现实,在项目的config目录下必须要有production.json配置文件,但是官方没有说明,官方项目在该目录下也没有该production.json配置文件
##### 制作镜像 docker build -t easy-mock:1.5.1 .

> 必须谨记, 不是所有镜像都可以作为基础制作其他镜像的, 有些镜像的系统本身就不支持应用的某些命令, 用了这些镜像, 在制作过程中, 可能镜像会制作失败
> 曾经用了node:10.1-alpine制作easy-mock镜像,但是在执行 npm run build命令时抛程序异常, 不抛系统层面的异常, 但是用 unbuntu:16.04 镜像时却没有抛任何异常
##### docker run -itd --name easy-mock -e MONGODB_URI=192.168.1.169:27017/easy-mock -e REDIS_HOST=192.168.1.169 -e REDIS_PORT=6379 -p 7300:7300 easy-mock:1.5.1

