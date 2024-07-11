#### golang-1.22.5

* 明确使用GOLANG的版本是1.22，安装包名称是 go1.22.5.windows-amd64.zip ，GOLANG不少命令在不断变更，不兼容旧版本，很多命令都放弃不维护，因此指定当前博客版本是1.22.5

#### GOLANG环境变量
* GOPATH环境变量主要是配置安装插件的路径，同时把%GOPATH%\bin配置到PATH环境变量，安装的插件就可以直接通过命令行使用
* GOROOT环境变量配置golang的安装路径
* PATH环境变量添加 %GOPATH%\bin 和 %GOROOT%\bin
* GOPROXY环境变量配置插件下载加速器

> 当我们执行go mod download 或 go mod tidy等命令下载依赖包时，golang首先会通过GOPROXY环境变量设置的镜像站点去下载。GOPROXY默认值为 https://proxy.golang.org,direct，它的意思是：下载依赖包时，首先从代理站点https://proxy.golang.org处进行下载，如果下载失败，再直接从官网下载。

> 安装插件的命令 go get -u github.com/gin-gonic/gin 在1.22.5版本是废弃的，要使用 go install github.com/gin-gonic/gin 下载

##### 创建项目步骤
```
# 先创建目录，在去目录初始化项目，此时目录就是项目代码根路径
mkdir -p testProject
cd testProject

# 创建项目 go mod init
go mod init testProject

# 添加gin的web依赖
go get github.com/gin-gonic/gin

# 运行项目
go run main.go

# 打包编译项目
go build main.go

```

#### 参考博客 https://cloud.tencent.com/developer/article/2103444

