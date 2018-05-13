## postgresql命令

```shell
# 单独用docker跑mysql时,不能加sh -c执行多条命令,后面只能加一条命令,用docker-compose应该也不行
# 镜像后面直接加mysqld的参数就可以了
# docker run -d -e MYSQL_ROOT_PASSWORD=root mysql:5.7.16 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --innodb-flush-log-at-trx-commit=0 --log-timestamps=SYSTEM
# 查看所有参数  docker run -it --rm mysql:5.7.16 --verbose --help
docker stop mysql 
docker rm mysql
# docker run -itd --restart always -e MYSQL_ROOT_PASSWORD=root -v /etc/localtime:/etc/localtime:ro -p 3306:3306 --name mysql mysql:5.7.16 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --innodb-flush-log-at-trx-commit=0 --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
docker run -itd --restart always -e MYSQL_ROOT_PASSWORD=root -v /etc/localtime:/etc/localtime:ro -p 3306:3306 --name mysql mysql:5.7.16 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --default-time-zone='+8:00' --log-timestamps=SYSTEM --sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
docker logs mysql

```