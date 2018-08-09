
```
# 该命令的作用：用rsync命令拉取指定IP的指定路径的文件夹到本地指定路径
# 目标主机和本地主机都要安装reync软件，目标主机和本地主机可以是同一台，但是本地IP与本地一定要配置免密登录
# rsync -a -e ssh root@192.168.4.8:目标机主机径文件夹 本地主机路径
# 如果本地主机路径的最后一个目录不存在，rsync会自动创建，如果倒数第2个目录不存在的话，rsync直接抛错，rsync: mkdir "/var/server/backup/data" failed: No such file or directory (2)
# 下面这条命令的最终结果是/data/backup路径会有postgres目录，里面的内容与目标主机的/var/server/data/postgres的内容一样
rsync -a -e ssh root@192.168.4.8:/var/server/data/postgres /data/backup
```

```
.
├── icity-admin
│   ├── icity-admin-api
│   ├── icity-admin-client
│   └── icity-admin-service      public static void main(String[] args)
├── icity-common
│   └── src
├── icity-eureka                 public static void main(String[] args)
│   └── src
├── icity-genericdao
│   └── src
├── icity-iflow
│   ├── icity-iflow-api
│   ├── icity-iflow-client
│   └── icity-iflow-service      public static void main(String[] args)
├── icity-iform
│   ├── icity-iform-api
│   ├── icity-iform-client
│   └── icity-iform-service      public static void main(String[] args)
├── icity-ireport
│   ├── icity-ireport-api
│   ├── icity-ireport-client
│   └── icity-ireport-service    public static void main(String[] args)
├── icity-jpa
│   └── src
├── icity-rbac
│   └── src
└── icity-showcase              public static void main(String[] args)
    ├── src
    └── target
```