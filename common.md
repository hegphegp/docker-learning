# 常用命令

> docker跑的服务都不应该以后台的形式运行,docker检测不了后台运行服务的状态,是否是成功,是否是失败,导致docker启动的时候不断地restart, 例如redis以后台形式运行, docker run -itd --restart always redis redis-server --daemonize yes , 该命令启动的redis服务会失败

#### 查找容器名的部分名词字段
```
docker ps -a --filter name=redis -q
# 7c16765f5ef3
# ecba9578534c
# c1353a0c7231
# 8a3339228398
docker stop `docker ps -a -q --filter name=redis`
docker rm `docker ps -a -q --filter name=redis`
```
