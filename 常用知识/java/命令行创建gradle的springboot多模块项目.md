## 命令行创建gradle的springboot多模块项目

### shell脚本有很大的约束和限制
```shell
# 根目录项目名称, moduleProjectNames定义的是模块项目数组
rootProjectName=hhh
moduleProjectNames=(aaa,bb)
if [ -n $rootProjectName ]; then
    echo -e "\033[31m 根项目和项目模块不允许为空  \033[0m" && sleep 6 && exit
fi



mkdir -p $rootProjectName
for item in ${moduleProjectNames[@]};
    mkdir -p $rootProjectName/$item/src/main/{java,resources/static,resources/templates} web/src/test/{java,resources/static,resources/template}
do
    
done


```


## 命令行创建gradle的springboot多模块项目

##### 只能半自动化创建，不要想着全自动化创建，因为这样子写工具类和代码会很烂，而且这个工具类只能在首次创建使用，单独添加子模块不能用，这个功能太小众化了，很少人用
##### 漏写参数，脚本创建项目失败后，删掉重来
#### 新建项目目录
```shell
rootProjectName=11
moduleProjectNames=()

if [ -z "$rootProjectName" ] || [ -z "$moduleProjectNames" ]; then
    echo -e "\033[31m 根项目名称和项目模块不允许为空  \033[0m" && sleep 60 && exit
fi

mkdir -p $rootProjectName
cd $rootProjectName

for item in ${moduleProjectNames[@]}
do
done
moduleProjectNames=
```