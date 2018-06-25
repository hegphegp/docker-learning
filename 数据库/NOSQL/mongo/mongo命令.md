## mongo命令

##### 全库备份还原
```
# mongo备份还原
docker run -itd --name mongo -p 27017:27017 mongo:3.4.5
docker exec -it mongo sh
mkdir -p /mongo-backup
# 备份命令 mongodump --host IP地址 --port 27017 -o 目录
mongodump -h localhost -d local -p 27017 -o /mongo-backup
# 还原命令 mongorestore -h IP地址 --dir 目录，若数据库已存在辉抛错
mongorestore -h localhost -p 27017 --dir /mongo-backup
# 还原时，若数据库存在，加上 --drop　选项，删除旧数据库再导入
mongorestore -h localhost -p 27017 --dir /mongo-backup --drop
```

##### 全库备份
```
mongodump -h localhost -d local -p 27017 -o /mongo-backup
```

##### 全库还原
```
# 还原命令 mongorestore -h IP地址 --dir 目录，若数据库已存在辉抛错
mongorestore -h localhost -p 27017 --dir /mongo-backup
# 还原时，若数据库存在，加上 --drop　选项，删除旧数据库再导入
mongorestore -h localhost -p 27017 --dir /mongo-backup --drop
```

##### 单表数据的导出
```
mongoexport --host localhost --port 27017 --username quicktest --password quicktest --collection news --db editor --out /news.json
--host : 要导出数据库 ip
--port : 要导出的实例节点端口号
--username : 数据库用户名
--password : 数据库用户密码
--collection : 要导出的表名
--db : 要导出的表所在数据库名
--out : 要导出的文件路径(默认为当前文件夹)
```

##### 
```
mongoimport --host localhost --port 27019 --username quicktest --password quicktest --collection news --db editor --file /news.json
--host : 要导入的数据库 ip
--port : 要导入的实例节点端口号
--username : 数据库用户名
--password : 数据库用户密码
--collection : 要导入的表名
--db : 要导入的表所在数据库名
--file : 要导入的源文件路径(默认为当前文件夹)
```