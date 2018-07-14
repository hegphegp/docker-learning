# gopub企业级运维发布系统

#### shell是一种比较辣鸡的脚本语言，下面的命令不能一次性copy运行(如果全部写到shell脚本sh文件，我猜应该是可以执行)
#### 因为shell是辣鸡，所以无尽无奈

```
docker stop gopub-mysql;
docker rm gopub-mysql;
docker run -itd --name gopub-mysql -e MYSQL_ROOT_PASSWORD=root --restart always -v /etc/localtime:/etc/localtime:ro mysql:5.7.21 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --innodb-flush-log-at-trx-commit=0 --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
sleep 10;
docker exec -it gopub-mysql sh -c 'mysql -u root -proot -e "DROP DATABASE IF EXISTS walle; CREATE DATABASE walle DEFAULT character set utf8 collate utf8_general_ci; show databases;"';
## 人工间隔开这两条命令，因为shell是辣鸡，识别不了命令
docker stop gopub;
docker rm gopub;
docker run -itd --name gopub -e MYSQL_HOST=gopub-mysql -e MYSQL_PORT=3306 -e MYSQL_USER=root -e MYSQL_PASS=root -e MYSQL_DB=walle -p 8192:8192 --link gopub-mysql:gopub-mysql --restart always lc13579443/gopub:latest;
## 人工停顿6秒
docker logs gopub;


```