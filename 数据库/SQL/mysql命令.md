## mysql命令

```shell
# 单独用docker跑mysql时,不能加sh -c执行多条命令,后面只能加一条命令,用docker-compose应该也不行,docker要监测容器里面运行的进程来判断服务是否存活，应该是MySQL容器监测不了sh -c的命令的服务存活情况
# 镜像后面直接加mysqld的参数就可以了
# docker run -d -e MYSQL_ROOT_PASSWORD=root mysql:5.7.21 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --innodb-flush-log-at-trx-commit=0 --log-timestamps=SYSTEM
# 查看所有参数  docker run -it --rm mysql:5.7.16 --verbose --help
# docker run -itd --restart always -e MYSQL_ROOT_PASSWORD=root -v /etc/localtime:/etc/localtime:ro -p 3306:3306 --name mysql mysql:5.7.21 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --innodb-flush-log-at-trx-commit=0 --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
# docker run -itd --restart always -e MYSQL_ROOT_PASSWORD=root -v /etc/localtime:/etc/localtime:ro -p 3306:3306 --name mysql mysql:5.7.21 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'

# 
docker stop mysql 
docker rm mysql
# docker run -itd --restart always -e MYSQL_ROOT_PASSWORD=root -v /etc/localtime:/etc/localtime:ro -p 3306:3306 --name mysql mysql:8.0.11 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'
docker run -itd --restart always -e MYSQL_ROOT_PASSWORD=root -v /etc/localtime:/etc/localtime:ro -p 3306:3306 --name mysql mysql:8.0.11 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' --default_authentication_plugin=mysql_native_password
docker logs mysql
```

#### 不登录数据库，直接在命令行执行SQL语句
```
# 加多一个 -e 参数
mysql -u root -proot -e "show databases";
mysql -u root -proot -e "DROP DATABASE IF EXISTS walle; CREATE DATABASE walle DEFAULT character set utf8 collate utf8_general_ci;"
```
