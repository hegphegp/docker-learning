# vagrant常用命令

```
# 添加镜像到本地仓库
# vagrant box add [box-name] [box镜像文件或镜像名]

# 移除本地镜像
# vagrant box remove [box-name]

# 列出本地仓库的镜像
vagrant box list

# 查看虚拟机的信息
vagrant status

# vagrant ssh登录的虚拟机的名称来自于 config.vm.define :example1
# 可以用 vagrant status 查看
```