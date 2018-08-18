# neo4j

### 必须看懂官方的docker-entrypoint.sh脚本的运行参数配置的部分，才知道怎么去配置参数
## 有个很大的遗留问题，指定了-e NEO4j_AUTH=neo4j/admin123参数，但是首次访问网页是账号密码是neo4j/neo4j，登录之后还要手动修改登陆密码
```
docker stop neo4j
docker rm neo4j
docker run -itd --restart always \
--name neo4j \
-e NEO4j_AUTH=neo4j/admin123 \
-e NEO4J_dbms_tx__log_rotation_retention__policy="100M size" \
-e NEO4J_dbms_memory_pagecache_size=128M \
-e NEO4J_dbms_memory_heap_initial__size=128M \
-e NEO4J_dbms_memory_heap_max__size=256M \
-p 7474:7474 -p 7473:7473 -p 7687:7687 \
neo4j:3.4.5
```