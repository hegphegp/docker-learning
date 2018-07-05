## postgresql命令

```shell
# docker stop postgresql
# docker rm postgresql
# docker run -itd --name postgresql --restart always -v /opt/data/postgresql:/var/lib/postgresql/data -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres:9.6.1 postgres -c max_connections=500
# docker logs postgresql

docker stop postgresql
docker rm postgresql
docker run -itd --name postgresql --restart always -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres:9.6.1 postgres -c max_connections=500
docker logs postgresql

update 表 set address=replace(address,'茂名','高州')

# 备份数据库
docker exec -it postgresql sh
# 忽略某些表来备份全库
pg_dump -U postgres -T table1 -T table2 -f /var/lib/postgresql/data/database-2018-02-25-1844.sql 数据库名
exit
pg_dump -U postgres -f /postgres-backup/database-`date "+%Y%m%d-%H%M%S"`.sql 数据库名
pg_dump -U postgres -f /database-`date "+%Y%m%d-%H%M%S"`.sql cityworks
sudo mv /home/hgp/database/postgres/database-2018-02-25-1844.sql /data

# 备份指定表的结构和数据
pg_dump -U postgres -t table1 -f /var/lib/postgresql/data/user_event.sql 数据库名
sudo mv /home/hgp/database/postgres/user_event.sql /data

# psql导入数据
psql -h localhost -U postgres -d 数据库名 -f /user_event.sql
```