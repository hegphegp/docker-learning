# neo4j

### 必须看懂官方的docker-entrypoint.sh脚本的运行参数配置的部分，才知道怎么去配置参数
```
docker stop neo4j
docker rm neo4j
docker run -itd --restart always \
--name neo4j \
-e NEO4J_AUTH=neo4j/admin123 \
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
-e NEO4J_AUTH=neo4j/admin123 \
-e NEO4J_dbms_shell_enabled=true \
-e NEO4J_dbms_shell_host=0.0.0.0 \
-e NEO4J_dbms_shell_port=1337 \
-e NEO4J_dbms_tx__log_rotation_retention__policy=true \
-e NEO4J_dbms_memory_pagecache_size=128M \
-e NEO4J_dbms_memory_heap_initial__size=128M \
-e NEO4J_dbms_memory_heap_max__size=256M \
-e NEO4J_dbms_security_procedures_unrestricted=apoc.export.*,apoc.import.* \
-e NEO4J_apoc_export_file_enabled=true \
-e NEO4J_apoc_import_file_enabled=true \
-p 7474:7474 -p 7473:7473 -p 7687:7687 \
neo4j:3.4.5

# 前往 https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/3.4.0.4 下载 apoc-3.4.0.4-all.jar

docker cp apoc-3.4.0.4-all.jar neo4j:/var/lib/neo4j/plugins

docker restart neo4j

# 在浏览器的neo4j命令行执行下面命令, 会备份数据到 /var/lib/neo4j 目录
CALL apoc.export.cypher.all("exported.cypher",{})
CALL apoc.export.cypherAll("exported.cypher",{})

docker cp neo4j:/var/lib/neo4j/exported.cypher .

# 导入本地数据库, neo4j-shell是可以免密导入脚本的数据, 免密导入远程服务器的数据, 远程服务器必须开启dbms_shell_enabled=true
docker run -it --rm -e NEO4J_AUTH=neo4j/admin123 --name neo4j -v $PWD/cypher-shell.cypher:/cypher-shell.cypher neo4j:3.4.5 sh -c "neo4j start && sleep 6 && cat /cypher-shell.cypher | cypher-shell -a bolt://localhost:7687 --format verbose -u neo4j -p admin123"


docker run -itd --restart always --name neo4j -e NEO4J_AUTH=neo4j/admin123 -p 7474:7474 -p 7473:7473 -p 7687:7687 -v $PWD/cypher-shell.cypher:/cypher-shell.cypher neo4j:3.4.5
sleep 5
docker exec -it neo4j sh -c "cat /cypher-shell.cypher | cypher-shell -a bolt://localhost:7687 --format verbose -u neo4j -p admin123";
```