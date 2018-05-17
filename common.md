# 常用命令

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
