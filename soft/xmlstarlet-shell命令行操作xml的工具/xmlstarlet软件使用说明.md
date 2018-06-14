# xmlstarlet软件使用说明

#### xmlstarlet在shell命令中软件使用说明
* shell命令行操作xml的工具
* 可以格式化xml
* 通过xpath对节点进行增删查改

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
#### xmlstarlet的sel命令通过xpath输出内容不换行，所以加上 echo -e "\n\n" 换行
```shell
# 暂时没找到xmlstarlet格式化输出到文本的命令，只能先把命令结果输出到文本
echo "<xml><table><rec id=\"1\"><numField>123</numField><stringField>first string</stringField></rec><rec id=\"2\"><numField>346</numField><stringField>second string</stringField></rec><rec id=\"3\"><numField>-23</numField><stringField>third string</stringField></rec></table></xml>" > test.xml
xmlstarlet fo test.xml
xmlstarlet sel -T -t -m /xml/table/rec -v "concat(@id, '|', numField,'|', stringField)" -n test.xml
xmlstarlet sel -T -t -m /xml/table/rec -v "numField" -n test.xml
xmlstarlet sel -T -t -m /xml/table/rec -v "concat(@id, '|')" -n test.xml
xmlstarlet el -u test.xml #输出如下
# xml
# xml/table
# xml/table/rec
# xml/table/rec/numField
# xml/table/rec/stringField

xmlstarlet el test.xml #输出如下
# xml
# xml/table
# xml/table/rec
# xml/table/rec/numField
# xml/table/rec/stringField
# xml/table/rec
# xml/table/rec/numField
# xml/table/rec/stringField
# xml/table/rec
# xml/table/rec/numField
# xml/table/rec/stringField

# 查询具体节点的所有值
xmlstarlet sel -t -v /xml test.xml
xmlstarlet sel -t -v /xml/table test.xml
xmlstarlet sel -t -v /xml/table/rec test.xml
xmlstarlet sel -t -v xml/table/rec/numField test.xml
xmlstarlet sel -t -v xml/table/rec/stringField test.xml

# xpath查询具体值，下标都是从1开始的
xmlstarlet sel -t -v /xml[1] test.xml && echo -e "\n\n"
xmlstarlet sel -t -v /xml[1]/table test.xml && echo -e "\n\n"
xmlstarlet sel -t -v /xml/table[1] test.xml && echo -e "\n\n"
xmlstarlet sel -t -v /xml[1]/table[1] test.xml && echo -e "\n\n"
xmlstarlet sel -t -v /xml/table/rec[1] test.xml && echo -e "\n\n"
xmlstarlet sel -t -v /xml/table[1]/rec[1] test.xml && echo -e "\n\n"
xmlstarlet sel -t -v /xml/table[1]/rec[2] test.xml && echo -e "\n\n"
xmlstarlet sel -t -v xml/table/rec[1]/numField test.xml && echo -e "\n\n"
xmlstarlet sel -t -v xml/table[1]/rec[1]/numField test.xml && echo -e "\n\n"

# 通过xpath删除节点
xmlstarlet ed -d xml/table[1]/rec[1] test.xml

# 通过xpath修改节点的值
xmlstarlet ed -u xml/table[1]/rec[1]/numField -v ======================= test.xml
# 通过xpath修改节点的值(内容有xml标签，会被转义掉，然后将文本替换回去)
xmlstarlet ed -u xml/table[1]/rec[1]/numField -v "<a>00000000000000000</a>" test.xml

# 通过xpath给节点添加上属性的名称和属性的值
xmlstarlet ed -i /xml/table/rec[1] -t attr -n age -v 88 test.xml
# 通过xpath添加同级别的节点和内容,该节点排在同级节点的前面
xmlstarlet ed -i /xml/table/rec[1] -t elem -n node -v value test.xml
xmlstarlet ed -i /xml/table/rec[1]/numField -t elem -n node -v value test.xml

# 通过xpath添加同级别的节点和内容,该节点排在同级节点的后面
xmlstarlet ed -a /xml/table/rec[1] -t elem -n node -v value test.xml
xmlstarlet ed -a /xml/table/rec[1]/numField -t elem -n node -v value test.xml

# 通过xpath添加直系子节点
xmlstarlet ed -s /xml/table/rec[1] -t elem -n node -v value test.xml
xmlstarlet ed -s /xml/table/rec[1]/numField -t elem -n node -v value test.xml
```