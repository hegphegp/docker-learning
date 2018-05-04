## postgresql命令

```
update 表 set address=replace(address,'茂名','高州')

# 备份数据库
docker exec -it postgresql sh
pg_dump -U postgres -T bpuser_location -T user_location -f /var/lib/postgresql/data/cityworks-2018-02-25-1844.sql cityworks
exit
#pg_dump -U postgres -f /postgres-backup/cityworks-`date "+%Y%m%d-%H%M%S"`.sql cityworks
#pg_dump -U postgres -f /cityworks-`date "+%Y%m%d-%H%M%S"`.sql cityworks
sudo mv /home/ascs/database/postgres/cityworks-2018-02-25-1844.sql /data
```