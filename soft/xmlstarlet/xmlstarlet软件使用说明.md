# xmlstarlet软件使用说明

* xmlstarlet在shell命令中直接可以格式化xml, xpath查询xml


* alpine没有xmlstarlet安装包，debian有xmlstarlet安装包，因此用bebian镜像
```
# 构建命令
docker build -t xmlstarlet .
```

#####样例xml文件
```xml
<?xml version="1.0"?>
<xml>
  <table>
    <rec id="1">
      <numField>123</numField>
      <stringField>first string</stringField>
    </rec>
    <rec id="2">
      <numField>346</numField>
      <stringField>second string</stringField>
    </rec>
    <rec id="3">
      <numField>-23</numField>
      <stringField>third string</stringField>
    </rec>
  </table>
</xml>
```

####
####
```shell
# 暂时没找到xmlstarlet格式化输出到文本的命令，只能先把命令结果输出到文本
echo "<xml><table><rec id="1"><numField>123</numField><stringField>first string</stringField></rec><rec id="2"><numField>346</numField><stringField>second string</stringField></rec><rec id="3"><numField>-23</numField><stringField>third string</stringField></rec></table></xml>" > test.xml
xmlstarlet fo test.xml
```