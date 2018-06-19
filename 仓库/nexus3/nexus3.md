# nexus3仓库的配置

```
# nexus3没有离线下载索引，没有离线配置索引和没有在线更新索引
su root
mkdir -p /opt/soft/nexus3
# 必须把挂载目录赋予200用户，如果赋予其他用户的话，启动两三分钟后容器日志显示没有权限，要么不挂载，要么挂载目录赋予200用户
chown -R 200 /opt/soft/nexus3
# 以下docker命令执行后要等5分钟再去访问 18081 端口才行
docker run -itd  --restart always -p 18081:8081 --name nexus -v /opt/soft/nexus3:/nexus-data sonatype/nexus3:3.12.1
```