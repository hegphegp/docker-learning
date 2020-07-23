#### elasticsearch

* 在关系型数据库中，需要先创建database和table后才可以插入数据。而es可以直接插入数据，会自动建立缺失的index和doc_type，并对字段建立mapping。
* 给某个索引添加一条数据后，就不能再给索引配置字段分词了，只能删掉重新录入数据
* 但是es自动创建的mapping不是万能的，必须手动定义Mapping。例如，es默认的中文分词是一个字一个字分的，因此要引入第三方的中文分词插件，并手动创建Mapping；有些字段是不需要索引的，es默认给每个字段创建索引，会消耗CPU，内存和硬盘空间
* 如果es默认创建了索引并录入了数据，只能删掉旧的索引重新录入数据。
* number_of_replicas : 一般是2(shards+replicas就为3了，相当于有3份数据),多则就为4(shards+replicas就为5了，相当于有5份数据)

##### 过程中遇到的问题和解决方法
```
# 我在docker容器指定运行参数时抛出以下异常
# [LNVgu_1] bound or publishing to a non-loopback address, enforcing bootstrap checks  
# ERROR: [1] bootstrap checks failed  
# [1]: max virtual memory areas vm.max_map_count [26200] is too low, increase to at least [262144]  

# 遇到上面异常的原因是 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" 限制Java内存(在全新的系统测试过,增大内存的参数ES_JAVA_OPTS="-Xms384m -Xmx384m"是无效的)

# 直接在docker的宿主机运行下面这条命令，修改vm.max_map_count参数(在全新的系统测试过,增大内存的参数ES_JAVA_OPTS="-Xms384m -Xmx384m"是无效的)
sysctl -w vm.max_map_count=262144
```

#### 要学习的方面
```
1) Document APIs 里的所有内容
2) Search APIs 下的 Search、URI Search、Request Body Search
3) Query DSL 下的 Query and filter context、Match All Query、Full text queries下的Match Query， Compound queries下的 Bool Query， Joining queries下的 Nested Query。
4) Term level queries下的 Term Query、Terms Query、Rangge Query。这在查询时会用到。
5) Mapping下Field datatypes下的Array datatype、Binary datatype、Range datatype、Boolean datatype、Date datatype、Object datatype、String datatype、Text datatype；这里根据自己想买需求可多看一些其他的，这里讲解的是ES所支持的数据类型。
```

#### 实践的功能点
```
# 提供一份初始化数据和脚本
1) 计算n台服务器下，shards和replicas的最优比例，保证挂了多台服务器，整个集群还可以正常运行
2) 给某个索引添加mapping，该mapping要包含两个以上的type，指定某些字段不需要被搜索
3) 给某个type的mapping添加一两个字段
4) 对某个type进行搜索分页
5) 给对象内嵌对象的type建索引
6) 给type的数组对象建索引
7) 查看某个type的索引
8) 各种复杂查询，多条件查询
9) 提供一份数据导入脚本，创建大量模拟数据测试
10) 怎么搭建集群
11) 集群节点挂断，重启后怎么恢复数据

Elasticsearch实战系列-restful api使用 https://blog.csdn.net/top_code/article/details/50733257
```

##### 实验前的准备条件
```
docker stop elasticsearch
docker rm elasticsearch
docker run -itd --restart always -p 9200:9200 -p 9300:9300 -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e "discovery.type=single-node" --name elasticsearch elasticsearch:7.7.1
docker logs -f --tail=300 elasticsearch
```

##### 查询搜索文档
```
# 不装插件，只能用POST请求批量删除某个doc type的所有文档
curl -X POST http://localhost:9200/school/student/_delete_by_query?conflicts=proceed -d '{"query":{"match_all":{}}}'
curl -X POST http://localhost:9200/school/student -d '{"username":"username", "age":12}'
curl -X POST http://localhost:9200/school/student -d '{"username":"username", "age":13}'
curl -X POST http://localhost:9200/school/student -d '{"username":"user name user name", "age":120}'
curl -X POST http://localhost:9200/school/student -d '{"username":"user name user name", "age":122}'

curl -X GET http://localhost:9200/school/student/_search -d '{"query":{"match_all":{}}}'

# 分页搜索查询
curl -X GET http://localhost:9200/school/student/_search -d '{"from":1, "size":100}'
curl -X GET http://localhost:9200/school/student/_search -d '{"from":1, "size":1}'
curl -X GET http://localhost:9200/school/student/_search -d '{"from":1, "size":100}'
# curl -X GET http://localhost:9200/school/student/_search -d '{"query":{"match_all":{}}, "from":1, "size":100}'
curl -X POST http://localhost:9200/school/student/_search -d '{"from":1, "size":1}'
curl -X POST http://localhost:9200/school/student/_search -d '{"from":1, "size":100}'


# 条件查询
curl -X GET http://localhost:9200/school/student/_search?pretty -d '{"query":{"match":{"username":"name"}}}'
```

##### type中存在内嵌对象的Mapping创建过程(json文件不是人眼可以维护的)
```
# 根据以下这个json对象的创建Mapping
{
    "id": 1000017,
    "name": "username",
    "daily_budget": 410000,
    "schedule_info": {
        "date": [
            { "start": "2017-04-20", "end": "2017-04-20" }, 
            { "start": "2017-04-20", "end": "2017-04-20" }
        ],
        "time": [
            { "start": "00:00", "end": "23:59" }, 
            { "start": "00:00", "end": "23:59" }
        ]
    },
    "serving_speed": 0,
    "create_time": 1492694481227,
    "start_schedule": 1492694481227,
    "end_schedule": 1499994481227,
    "create_user": "admin",
    "update_user": "unknown"
}

# 创建Mapping
curl -X DELETE http://localhost:9200/author
curl -X PUT http://localhost:9200/author -d '
{
  "order": 0,
  "template": "Yaohong-plan-*",
  "settings": {
    "index": {
      "number_of_replicas": "1",
      "number_of_shards": "5",
      "refresh_interval": "1s"
    }
  },
  "mappings": {
    "event": {
      "properties": {
        "update_user": {
          "type": "keyword",
          "index": "not_analyzed"
        },
        "status": {
          "type": "integer"
        },
        "end_schedule": {
          "type": "date",
          "format": "yyyy-MM-dd HH:mm:ss||epoch_millis"
        },
        "serving_speed": {
          "type": "integer"
        },
        "id": {
          "type": "long"
        },
        "update_time": {
          "type": "date",
          "format": "yyyy-MM-dd HH:mm:ss||epoch_millis"
        },
        "start_schedule": {
          "type": "date",
          "format": "yyyy-MM-dd HH:mm:ss||epoch_millis"
        },
        "daily_budget": {
          "type": "integer"
        },
        "create_time": {
          "type": "date",
          "format": "yyyy-MM-dd HH:mm:ss||epoch_millis"
        },
        "create_user": {
          "type": "keyword",
          "index": "not_analyzed"
        },
        "schedule_info": {
          "type":"nested",
          "properties":{
            "date":{
              "properties":{
                "start":{
                  "type":"date",
                  "format":"yyyy-MM-dd||epoch_millis"
                },
                "end":{
                  "type":"date",
                  "format":"yyyy-MM-dd||epoch_millis"
                }
              }
            },
            "time":{
              "properties":{
                "start":{
                  "type":"integer"
                },
                "end":{
                  "type":"integer"
                }
              }
            }
          }
        }
      }
    }
  }
}
'

# 插入数据
curl -X POST http://localhost:9200/author/event -d '
{
    "id": 1000017,
    "name": "username",
    "daily_budget": 410000,
    "schedule_info": {
        "date": [
            { "start": "2017-04-20", "end": "2017-04-20" }, 
            { "start": "2017-04-20", "end": "2017-04-20" }
        ],
        "time": [
            { "start": "12345678", "end": "22345678" }, 
            { "start": "12345678", "end": "22345678" }
        ]
    },
    "serving_speed": 0,
    "create_time": 1492694481227,
    "start_schedule": 1492694481227,
    "end_schedule": 1499994481227,
    "create_user": "admin",
    "update_user": "unknown"
}
'

# 按时间范围查询
curl -X GET http://localhost:9200/author/event/_search -d '
{
  "query": {
    "bool": {
      "must": [{
        "term": {
          "status": "0"
        }
      }, {
        "nested": {
          "query": {
            "bool": {
              "filter": [{
                "range": {
                  "schedule_info.date.start": {
                    "from": "2017-03-05",
                    "to": null,
                    "format": "yyyy-MM-dd",
                    "include_lower": true,
                    "include_upper": true
                  }
                }
              }, {
                "range": {
                  "schedule_info.date.end": {
                    "from": null,
                    "to": "2017-09-12",
                    "format": "yyyy-MM-dd",
                    "include_lower": true,
                    "include_upper": true
                  }
                }
              }]
            }
          },
          "path": "schedule_info"
        }
      }],
      "should": {
        "match": {
          "name": {
            "query": "YangHong",
            "type": "boolean"
          }
        }
      }
    }
  }
}
'
```

##### 
```
ES中的Bool查询有三种状态，分别是must，should，must_not。
1) must 相当于 SQL 的 and条件，比如你用SQL查询价格，你会写出如下sql语句：
select * from table_name where id = 1000 and price = 50;

2) shoud相当于SQL 的 or条件，例如：
select * from table_name where id = 1000 or price = 50;

3) must_not 相当于SQL的not in，例如：
select * from table_name where id not in(1000);

# 对于大于等于，区间值等，官方文档中有详细的说明
```
