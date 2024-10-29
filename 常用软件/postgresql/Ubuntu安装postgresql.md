## Ubuntu安装postgresql

#### ubuntu-22.04.3通过apt-get安装postgresql
```

# 通过 apt list 可以列出 PostgreSQL 相关的软件包
apt list | grep postgresql

# apt安装postgresql，此时的数据库版本是postgresql-14
apt install postgresql # 会自动化初始化数据库，后面手动初始化数据库

# 设置postgresql成为systemctl进程
systemctl enable postgresql

# 查看postgresql进程
ps -ef | grep postgres
netstat -anlp | grep 5432

# whereis命令查看软件的安装目录，可以看到，软件都被安装到上面三个目录
whereis -u postgresql
# postgresql: /usr/lib/postgresql /etc/postgresql /usr/share/postgresql

# 创建数据库存储目录
mkdir -p /opt/data/postgres14 # 数据库初始化目录，初始化后该目录生成的 pg_hba.conf/postgresql.conf 都是无效配置
sudo chown -R postgres:postgres /opt/data/postgres14
sudo chmod -R 0700 /opt/data/postgres14

# 使用 initdb 初始化数据库
sudo -u postgres /usr/lib/postgresql/14/bin/initdb -D /opt/data/postgres14

# 修改监听网卡和端口，以及数据存储目录data_directory，vim /etc/postgresql/14/main/postgresql.conf
listen_addresses = '*'
data_directory = '/opt/data/postgres14' # 手动初始化目录

# 修改 vim /etc/postgresql/14/main/pg_hba.conf 文件，设置可以远程登陆，不能设置trust(可以无密码登陆)
echo 'host    all       postgres     0.0.0.0/0      md5' >> /etc/postgresql/14/main/pg_hba.conf

# 改配置重新数据库重新加载
systemctl restart postgresql

# 刚安装的数据库还没有登录密码，可以切换postgres账号直接登录
sudo -i -u postgres
psql

ALTER USER postgres WITH PASSWORD 'postgres123#@!';



```