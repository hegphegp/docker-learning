### 同宿主机的postgres主从容器搭建.md

```
docker pull registry.cn-hangzhou.aliyuncs.com/hegp/postgres-zhparser:11.10-alpine
docker tag registry.cn-hangzhou.aliyuncs.com/hegp/postgres-zhparser:11.10-alpine postgres:11.10-alpine
docker rmi registry.cn-hangzhou.aliyuncs.com/hegp/postgres-zhparser:11.10-alpine


# 创建宿主机网段
docker stop pg-master pg-slave
docker rm pg-master pg-slave
docker network rm postgres-network
docker network create --subnet=172.77.0.0/24 postgres-network
# 在 /opt/soft/postgres/master-slave ，用root账号操作
rm -rf /opt/soft/postgres/master-slave && mkdir -p /opt/soft/postgres/master-slave
cd /opt/soft/postgres/master-slave

mkdir -p /opt/soft/postgres/master-slave/master
mkdir -p /opt/soft/postgres/master-slave/slave-tmp  # 临时使用复制数据，先把主节点的数据复制到这个目录，然后重命名为 slave

#### 步骤01) 创建主节点容器
# docker run -itd --network postgres-network --ip 172.77.0.101 --name pg-master -e LANG="C.UTF-8" -e 'TZ=Asia/Shanghai' -e "POSTGRES_DB=postgres" -e "POSTGRES_USER=postgres" -e "POSTGRES_PASSWORD=postgres" -v /opt/soft/postgres/master-slave/master:/var/lib/postgresql/data postgres:11.10-alpine

docker run -itd --network postgres-network --ip 172.77.0.101 --name pg-master -e "POSTGRES_USER=postgres" -e "POSTGRES_PASSWORD=postgres" -v /opt/soft/postgres/master-slave/master:/var/lib/postgresql/data postgres:11.10-alpine

sleep 15 # 等待postgresql完全跑起来
# 创建主从流复制专用账号，用navicat运行下面命令，或者用docker exec 执行指令
# CREATE ROLE repuser WITH LOGIN REPLICATION CONNECTION LIMIT 5 PASSWORD 'Q1w2E#';
docker exec -it pg-master psql -U postgres -c "CREATE ROLE repuser WITH LOGIN REPLICATION CONNECTION LIMIT 5 PASSWORD 'Q1w2E#';"

######################### 停止copy ########################

#### 步骤02) 配置postgresql的参数
# 在 /opt/soft/postgres/master-slave/master/pg_hba.conf 文件添加一行内容
# echo "host replication repuser 172.77.0.102/24 md5" >> /opt/soft/postgres/master-slave/master/pg_hba.conf
# echo "host replication repuser 172.77.0.102/24 trust" >> /opt/soft/postgres/master-slave/master/pg_hba.conf # 后面的参数，表示可以该IP可以免密登录
echo "host replication repuser 172.77.0.102/24 md5" >> /opt/soft/postgres/master-slave/master/pg_hba.conf

# /opt/soft/postgres/master-slave/master/postgresql.conf文件中以下几个参数，并调整如下，该文件在 pg-11.08版本有将近700行，小心改错参数
# archive_mode = on
# archive_command = '/bin/date' # 用该命令来归档logfile segment，这里取消归档。
# wal_level = replica # 开启热备
# max_wal_senders = 10
# wal_keep_segments = 16
# wal_sender_timeout = 60s ＃ 设置流复制主机发送数据的超时时间
## synchronous_standby_names = '*' # 设置了，就是同步复制，备库提交成功后，主库再提交。我们部署的数据库备库节点做不到100%高可用，备库不可用，主库就提交不了，会引发血案的，毕竟曾经被坑得很惨
cd /opt/soft/postgres/master-slave/master
sed -ri "s|^#?archive_mode\s+.*|archive_mode = on|" postgresql.conf
sed -ri "s|^#?archive_command\s+.*|archive_command = '/bin/date'|" postgresql.conf
sed -ri "s|^#?wal_level\s+.*|wal_level = replica|" postgresql.conf
sed -ri "s|^#?max_wal_senders\s+.*|max_wal_senders = 10|" postgresql.conf
sed -ri "s|^#?wal_keep_segments\s+.*|wal_keep_segments = 16|" postgresql.conf
sed -ri "s|^#?wal_sender_timeout\s+.*|wal_sender_timeout = 60s|" postgresql.conf
## sed -ri "s|^#?synchronous_standby_names\s+.*|synchronous_standby_names = '*'|" postgresql.conf
## 当synchronous_standby_names未被设置时，表示异步复制
## 当synchronous_standby_names被设置时，表示同步复制

# 重启主库使配置生效，使用 pg_ctl stop 安全停止数据库， docker exec -it -u postgres pg-master pg_ctl stop
docker restart pg-master

######################### 停止copy ########################

# 步骤03) 创建从服务器
docker run -itd --network postgres-network --ip 172.77.0.102 --name pg-slave -e "POSTGRES_USER=postgres" -e "POSTGRES_PASSWORD=postgres" -v /opt/soft/postgres/master-slave/slave-tmp:/slave-data postgres:11.10-alpine
sleep 10 # 等待从库完成跑起来
# 进入从库容器，同步初始主库数据到 repl 目录
docker exec -it pg-slave bash
# pg_basebackup -F p --progress -D /slave-data -h 172.77.0.101 -p 5432 -U repuser --password
pg_basebackup -R -D /slave-data -Fp -Xs -v -P -h 172.77.0.101 -p 5432 -U repuser -W

######################### 停止copy，上面的命令要输入密码 ########################

exit

######################### 停止copy，上面的命令要输入密码 ########################

# 步骤04) 删掉pg-slave容器，然后把 /opt/soft/postgres/master-slave/slave-tmp 重名为 /opt/soft/postgres/master-slave/slave，然后修改配置参数
docker stop pg-slave
docker rm pg-slave
mv /opt/soft/postgres/master-slave/slave-tmp /opt/soft/postgres/master-slave/slave


# /opt/soft/postgres/master-slave/slave/recovery.conf 文件确保有下面的内容 primary_conninfo
cd /opt/soft/postgres/master-slave/slave/
cat recovery.conf
# standby_mode = on    # 指明从库身份
# primary_conninfo = 'user=repuser password=''Q1w2E#'' host=172.77.0.101 port=5432 sslmode=prefer sslcompression=0 krbsrvname=postgres target_session_attrs=any'
echo "recovery_target_timeline = 'latest'" >> recovery.conf


# /opt/soft/postgres/master-slave/slave/postgresql.conf文件中以下几个参数，并调整如下，该文件在 pg-11.08版本有将近700行，小心改错参数
# wal_level = replica # 开启热备
# hot_standby = on
# hot_standby_feedback = on
cd /opt/soft/postgres/master-slave/slave
sed -ri "s|^#?wal_level\s+.*|wal_level = replica|" postgresql.conf
sed -ri "s|^#?hot_standby\s+.*|hot_standby = on|" postgresql.conf
sed -ri "s|^#?hot_standby_feedback\s+.*|hot_standby_feedback = on|" postgresql.conf


docker run -itd --network postgres-network --ip 172.77.0.102 --name pg-slave -e "POSTGRES_USER=postgres" -e "POSTGRES_PASSWORD=postgres" -v /opt/soft/postgres/master-slave/slave:/var/lib/postgresql/data postgres:11.10-alpine


```