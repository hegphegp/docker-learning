### rap2接口文档

```
tee docker-compose.yml <<-'EOF'
# 如果 Sequelize 报错可能是数据库表发生了变化，运行下面命令同步
# docker-compose exec delos node scripts/updateSchema

version: "3"

services:
  dolores: # 前端模块
    restart: always
    image: rapteam/rap2-dolores:rap2org
    ports:
      - 3000:38081  # 冒号前可以自定义前端端口号，冒号后不要动，该镜像的nginx配置文件/etc/nginx/conf.d/nginx.conf 监听的是38081端口

  delos:  # 后端模块
    restart: always
    image: rapteam/rap2-delos:rap2org
    command: node dispatch.js
    ports:
      - 38080:38080
    environment:
      - SERVE_PORT=38080
      - MYSQL_URL=mysql
      - MYSQL_PORT=3306
      - MYSQL_USERNAME=root
      - MYSQL_PASSWD=
      - MYSQL_SCHEMA=rap2
      - REDIS_URL=redis
      - REDIS_PORT=6379
      - NODE_ENV=production
    depends_on:
      - redis
      - mysql

  init-db:  # 比较无奈的地方，首次启动要初始化数据库，只能运行一次，否则多次执行会覆盖上一次的数据
    image: rapteam/rap2-delos:rap2org
    command: node scripts/init
    environment:
      - MYSQL_URL=mysql
      - MYSQL_PORT=3306
      - MYSQL_USERNAME=root
      - MYSQL_PASSWD=
      - MYSQL_SCHEMA=rap2
      - REDIS_URL=redis
      - REDIS_PORT=6379
      - NODE_ENV=production
    depends_on:
      - redis
      - mysql

  redis:
    restart: always
    image: redis:5.0.5-alpine

  mysql:
    restart: always
    image: mysql:5.7.29
    volumes:
      - "./data/mysql/volume:/var/lib/mysql"
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --init-connect='SET NAMES utf8mb4;' --innodb-flush-log-at-trx-commit=0
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: "true"
      MYSQL_DATABASE: "rap2"
      MYSQL_USER: "root"
      MYSQL_PASSWORD: ""
    ports:
      - 35673:3306

EOF
```