## mongo常用操作

#### 数据类型
数据类型 | 描述
:---:|:---:
String | 字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。
Integer | 整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。
Boolean | 布尔值。用于存储布尔值（真/假）。
Double | 双精度浮点值。用于存储浮点值。
Min/Max keys | 将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。
Array | 用于将数组或列表或多个值存储为一个键。
Timestamp | 时间戳。记录文档修改或添加的具体时间。
Object | 用于内嵌文档。
Null | 用于创建空值。
Symbol | 符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。
Date | 日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。
Object ID | 对象 ID。用于创建文档的 ID。
Binary Data | 二进制数据。用于存储二进制数据。
Code | 代码类型。用于在文档中存储 JavaScript 代码。
Regular expression | 正则表达式类型。用于存储正则表达式。

#### 启动mongo
```
docker run -itd --restart always -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro --name mongo -v /opt/data/mongo/data:/data/db -p 27017:27017 -d mongo:4.4.0-bionic
```
#### 命令行终端进入mongo
```
docker exec -it mongo sh
mongo --help # 查看mongo命令的帮助文档
mongo # 缺省参数进入
mongo --host localhost --port 27017 # 指定参数进入
```
#### 常用mongo命令，双斜杠是mogno的注释
```
db                                          // 查看当前的数据库
show dbs                                    // 显示所有数据库列表
show collections                            // 查看当前数据库已有集合
db.stats()                                  // 查看数据库状态
use                                         // 切换到某个数据库
db.dropDatabase()                           // 删除数据库(需要先切换到对应的数据库),(用的时候自己创建)
db.createCollection('coll1')                // 创建集合(也可以不创建，在插入数据时会自动生成)
db.createCollection(name, options)          // 创建集合(也可以不创建，在插入数据时会自动生成)

db.${collection}.drop()                     // 删除集合
db.${collection}.insert()                   // 插入文档
db.${collection}.save()                     // 插入文档
db.${collection}.findOne()                  // 查看一篇文档
db.${collection}.find().pretty()            // 以更加友好的方式查看已插入文档
db.${collection}.update()                   // 更新文档
db.${collection}.remove()                   // 删除文档；但是并不会释放存储空间，需执行db.repairDatabase() 来回收磁盘空间。推荐deleteOne() deleteMany()
db.${collection}.deleteMany({})             // 删除全部文档
db.${collection}.deleteOne({})              // 删除符合条件的一个文档
db.${collection}.find().limit(n)            // 读取n条数量的数据记录；
db.${collection}.find().limit(n).skip(m)    // 跳过m条数据后取n条数据
db.${collection}.find().sort({${key}:1})    // 排序，1升序，-1降序
db.${collection}.createIndex()              // 创建索引
db.${collection}.help()                     // 查询对相应表的一些操作
db.mycoll.find().help()                     // 查询的方法，排序，最大最小等等
```

#### insert()和save()方法的区别
* insert: 若新增数据的主键已经存在，会抛错
* save:   若新增数据的主键已经存在，会更新数据
```
db.person.insert({ _id:1, name:"zs" })  // 成功
db.person.insert({ _id:1, name:"zs" })  // 失败
```


#### 测试例子和数据
* find(${where条件}，${0和1控制返回字段})   如果没有查询，那就用{}表示，不能省略。而显示与否的{}可以省略的
- db.student.find({name:"name1"},{name:1,age:1})
- db.student.find({},{name:1,age:1})
```
db.student.save({_id:1,classid:1,age:18,name:"name1",love:["football","swing","cmpgame"]});
db.student.save({_id:2,classid:2,age:19,name:"name2",love:["play"]});
db.student.save({_id:3,classid:2,age:20,name:"name3"});
db.student.save({_id:4,classid:1,age:21,name:"name4"});
db.student.save({_id:5,classid:1,age:22,name:"name5",opt:"woshisheia"});
db.student.save({_id:6,classid:2,age:23,name:"2name4"});

db.student.find({},{name:1,age:1})
db.student.find({name:"name1"},{name:1,age:1})
db.student.find({'$or':[{name:'name3'},{age:19}]});            // select * from student where name = "little3" or age = 19
db.student.find({'$or':[{name:'name3'},{age:19}]},{name,1});   // select name from student where name = "little3" or age = 19

db.student.find({age:{$gt:19,$lte:21}});                       // 查询出19<age<=21的数据
db.student.find({age:{$gt:20}});                               // 查询age>20的数据
db.student.find({$where:"this.age>20"});
db.student.find("this.age>20");
var f = function(){return this.age>20};
db.student.find(f);

db.student.find({opt:{$exists:true}});                         // $exists：查询出存在opt字段的数据,  存在true，不存在false
db.student.find({opt:{$exists:false}});                        // $exists：查询出存在opt字段的数据,  存在true，不存在false

db.student.find({age:{$in:[16,18,19]}});                       // $in:查询出age为16，18，19的数据

db.student.find({age:{$nin:[16,18,19]}});                      // $nin:查询出age不为16，18，19的数据

db.student.find({love:{$size:3}});                             // $size:查询出love有三个的数据

db.student.find({name:{$not:/^litt.*/}});                      // 查询出name不是以litt开头的数据

// like模糊查询
db.student.find({name:/little/});                              // 相当于 select * from student where name like "%little%";
db.student.find({name:/^little/});                             // 相当于 select * from users where name like "little%";

// type属性类型判断，常见的Double 是1，String是2，Boolean是8，Date是9，Null是10，32位int是16，Timestamp是17，64位int是18
db.sutdent.find({"title":{$type:2}})
db.student.find({"title":{$type:'string'}})
```


### 更新操作
###### 更新命令格式
```
db.collection.update(
    <query>,                        // 必填，update的查询条件，类似sql update查询内where后面的。
    <update>,                       // 必填，update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
    {
        upsert: <boolean>,          // 可选，这个参数的意思是，如果不存在匹配的记录，是否插入新对象，true为插入，默认是false，不插入。
        multi: <boolean>,           // 可选，mongodb 默认是false，只更新找到的第一条记录，如果这个参数为true，就把按条件查出来多条记录全部更新。
        writeConcern: <document>    // 可选，抛出异常的级别。
    }
)

db.person.update({"name":"li"},{$set:{"age":8}})                         // 将age=10的数据改成15，默认如果age=10的有多条记录只更新第一条
db.person.update({"age":1},{$set:{"age":8}},{multi:true,upsert:true})    // 更新多个满足条件的值,同时如果更新的值不存在就插入更新的值，注意：这里插入的值是20不是30
db.person.update({"age":1},{$set:{"age":8}},true,true)                   // 值更新为数组
db.person.update({"name":"zhang"},{$set:{"age":[1,2,3]}},{upsert:true})  // 修改为其它的值
db.person.update({"name":"zhang"},{$set:{"age":''}},{upsert:true})
db.person.update({"name":"zhang"},{$set:{"age":null}},{upsert:true})


// $inc修改符，用于增加已有键的值，如果键不存在就创建，只能用于整形、长整型、浮点型。
db.person.update({"name":"zhang"},{$inc:{"age":10}},{upsert:true})         // 将name=zhang的记录的age键+10
db.person.update({"name":"zhang"},{$inc:{"age":-10}},{upsert:true})        // 将name=zhang的记录的age键-10

// $unset修改符，删除键类似关系数据库的删除字段操作，要区别$set修改符的将键设空或者null值
db.person.update({"name":"zhang"},{$unset:{"age":1}})
```

#### 索引
* 使用createIndex创建索引。创建索引，需要传递两个参数 (1)建立索引的字段名称 (2)排序参数，1升序，-1降序。
```
// 1) 建立单索引。
db.student.createIndex({name:1})         // 表示给name字段建立索引，按照升序的排序

// 2)建立复合索引。
db.student.ensureIndex({name:1,age:-1})  // 建立一个复合索引，表示给name和age都建立索引，按照name的升序，和age的降序
```