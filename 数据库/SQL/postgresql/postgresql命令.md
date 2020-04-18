## postgresql命令

##### postgresql可视化管理页面
```
docker run -itd --restart always --name pgadmin4 -e UPGRADE_CHECK_ENABLED=false -e PGADMIN_DEFAULT_EMAIL=testhgp@hgp.com -e PGADMIN_DEFAULT_PASSWORD=password -p 5050:80 dpage/pgadmin4:4.20
### pgadmin4有默认变量控制是否访问官网获取最新版本，但是国外网络不通，比较麻烦，所以禁止掉，可能还有很多访问国外的地方，但是不知道怎么全部找出来修改
docker exec -it -u root pgadmin4 sh -c "sed -i '/UPGRADE_CHECK_ENABLED/d' /pgadmin4/config.py; echo 'UPGRADE_CHECK_ENABLED = False' >> /pgadmin4/config.py"
docker restart pgadmin4

# docker run -itd --restart always --name pgadmin4 -e UPGRADE_CHECK_ENABLED=false -e PGADMIN_DEFAULT_EMAIL=testhgp@hgp.com -e PGADMIN_DEFAULT_PASSWORD=password -v /home/robert/data:/data -p 5050:80 dpage/pgadmin4:4.20
```

```shell
# docker stop postgresql
# docker rm postgresql
# docker run -itd --name postgresql --restart always -v /opt/data/postgresql:/var/lib/postgresql/data -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres:9.6.1 postgres -c max_connections=500
# docker logs postgresql

docker stop postgresql
docker rm postgresql
docker run -itd --name postgresql --restart always -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres:9.6.1 postgres -c max_connections=500
docker logs postgresql

update 表 set 字段名=replace(字段名,'旧的字符串','新的字符串')

# 备份数据库
docker exec -it postgresql sh
# 忽略某些表来备份全库
pg_dump -U postgres -T table1 -T table2 -d database -f /var/lib/postgresql/data/database-2018-02-25-1844.sql 数据库名
exit
pg_dump -U postgres -d database -f /postgres-backup/database-`date "+%Y%m%d-%H%M%S"`.sql 数据库名
pg_dump -U postgres -d database -f /database-`date "+%Y%m%d-%H%M%S"`.sql cityworks
sudo mv /home/hgp/database/postgres/database-2018-02-25-1844.sql /data

# 备份指定表的结构和数据
pg_dump -U postgres -t table1 -d database -f /var/lib/postgresql/data/user_event.sql 数据库名
sudo mv /home/hgp/database/postgres/user_event.sql /data

# psql导入数据
psql -h localhost -U postgres -d 数据库名 -f /user_event.sql

# 查询字段内容是否包含大小写字母和数字, 用到正则匹配查询
select * from sys_user where username ~ '[a-zA-Z1-9]';
select * from sys_user where username ~ '[a-z]';
select * from sys_user where username ~ '[A-Z]';
select * from sys_user where username ~ '[0-9]';
```