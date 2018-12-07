# neo4j

### 必须看懂官方的docker-entrypoint.sh脚本的运行参数配置的部分，才知道怎么去配置参数
## 有个很大的遗留问题，指定了-e NEO4j_AUTH=neo4j/admin123参数，但是首次访问网页是账号密码是neo4j/neo4j，登录之后还要手动修改登陆密码
```
docker stop neo4j
docker rm neo4j
docker run -itd --restart always \
--name neo4j \
-e NEO4j_AUTH=neo4j/admin123 \
-e NEO4J_dbms_tx__log_rotation_retention__policy=true \
-e NEO4J_dbms_memory_pagecache_size=128M \
-e NEO4J_dbms_memory_heap_initial__size=128M \
-e NEO4J_dbms_memory_heap_max__size=256M \
-p 7474:7474 -p 7473:7473 -p 7687:7687 \
neo4j:3.4.5
```

```
docker stop neo4j
docker rm neo4j
docker run -itd --restart always \
--name neo4j \
-e NEO4j_AUTH=neo4j/admin123 \
-e NEO4j_dbms_shell_enabled=true \
-e NEO4j_dbms_shell_host=0.0.0.0 \
-e NEO4j_dbms_shell_port=1337 \
-e NEO4J_dbms_tx__log_rotation_retention__policy=true \
-e NEO4J_dbms_memory_pagecache_size=128M \
-e NEO4J_dbms_memory_heap_initial__size=128M \
-e NEO4J_dbms_memory_heap_max__size=256M \
-e NEO4J_dbms_security_procedures_unrestricted=apoc.export.*,apoc.import.* \
-e NEO4J_apoc_export_file_enabled=true \
-e NEO4J_apoc_import_file_enabled=true \
-p 7474:7474 -p 7473:7473 -p 7687:7687 \
neo4j:3.4.5

# 前往 https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/3.4.0.3 下载 apoc-3.4.0.3-all.jar

docker cp apoc-3.4.0.3-all.jar neo4j:/var/lib/neo4j/plugins

docker restart neo4j

# 在浏览器运行下面的命令，可以备份数据到cypher语句，不要去看网上的教程，网上教程都是废物的，亲测浪费了很多生命
CALL apoc.export.cypher.all("exported.cypher",{})
CALL apoc.export.cypherAll("exported.cypher",{})
```