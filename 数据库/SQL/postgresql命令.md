## postgresql命令

```shell
# docker stop postgresql
# docker rm postgresql
# docker run -itd --name postgresql --restart always -v /opt/data/postgresql:/var/lib/postgresql/data -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_USER=ascs -e POSTGRES_PASSWORD=ascs.tech postgres:9.6.1 postgres -c max_connections=500
# docker logs postgresql

docker stop postgresql
docker rm postgresql
docker run -itd --name postgresql --restart always -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_USER=ascs -e POSTGRES_PASSWORD=ascs.tech postgres:9.6.1 postgres -c max_connections=500
docker logs postgresql

update 表 set address=replace(address,'茂名','高州')

# 备份数据库
docker exec -it postgresql sh
# 忽略某些表来备份全库
pg_dump -U postgres -T bpuser_location -T user_location -f /var/lib/postgresql/data/cityworks-2018-02-25-1844.sql cityworks
exit
pg_dump -U postgres -f /postgres-backup/cityworks-`date "+%Y%m%d-%H%M%S"`.sql cityworks
pg_dump -U postgres -f /cityworks-`date "+%Y%m%d-%H%M%S"`.sql cityworks
sudo mv /home/ascs/database/postgres/cityworks-2018-02-25-1844.sql /data

# 备份指定表的结构和数据
pg_dump -U postgres -t user_event -f /var/lib/postgresql/data/user_event.sql cityworks
sudo mv /home/ascs/database/postgres/user_event.sql /data
psql -h localhost -U postgres -d cityworks -f /user_event.sql
```