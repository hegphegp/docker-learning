# 各种restful接口命令讲解

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
12) 怎么集成Head插件

Elasticsearch实战系列-RESTful API使用  https://blog.csdn.net/top_code/article/details/50733257
{
    "email":      "john@smith.com",
    "first_name": "John",
    "last_name":  "Smith",
    "about": {
        "bio":         "Eco-warrior and defender of the weak",
        "age":         25,
        "interests": [ "dolphins", "whales" ]
    },
    "join_date": "2014/05/01",
}
```



##### 实验前的准备条件
```
docker stop single-elasticsearch
docker rm single-elasticsearch
docker run -itd --restart always -e ES_JAVA_OPTS="-Xms256m -Xmx256m" -p 9200:9200 --name single-elasticsearch elasticsearch:5.6.10-alpine
# 访问URL http://localhost:9200
curl http://localhost:9200
```

##### elasticsearch可以直接插入数据，系统会自动建立缺失的index和doc type，并对字段建立mapping。

##### elasticsearch创建索引(创建索引时传参数和不传参数的区别)
```
# 创建索引时，不传参数不会抛异常
curl -X PUT http://localhost:9200/school
# 创建索引时，可以通过很多参数来自定义索引行为，Elasticsearch提供了优化好的默认配置。最重要的参数是：number_of_shards和number_of_replicas
# number_of_shards：定义一个索引的主分片个数，默认值是5。这个配置在索引创建后不能修改。
# number_of_replicas：每个主分片的复制分片个数，默认是1。这个配置可以随时在活跃的索引上修改。
# 5.6.10版本用这条命令命令创建索引，但是其他版本用这条命令创建时，会抛参数不正确的异常信息
curl -X PUT http://localhost:9200/student -d '{"number_of_shards":1, "number_of_replicas":0}'
curl -X PUT http://localhost:9200/student1 -d '{"settings":{"number_of_shards":1, "number_of_replicas":0}}'
# 通过新增一个文档让es自动创建默认索引。事实上，你可以通过在config/elasticsearch.yml 中添加下面的配置来防止自动创建索引

# 创建索引时同时设置mapping，可以配置多个doc type的mapping
curl -X DELETE http://localhost:9200/author 
curl -X PUT http://localhost:9200/author -d '
{
    "mappings": {
        "man": {
            "properties": {
                "word_count": { "type": "integer" },
                "author": { "type": "keyword" },
                "title": { "type": "text" },
                "publish_date": {
                    "type": "date",
                    "format": "yyyy-MM-dd HH:mm:ss || yyyy-MM-dd || epoch_millis"
                }
            }
        },
        "woman": {}
    }
}
'

curl -X PUT http://localhost:9200/article -d '
{
    "number_of_shards": 1,
    "number_of_replicas": 0,
    "mappings": {
        "man": {
            "properties": {
                "word_count": { "type": "integer" },
                "author": { "type": "keyword" },
                "title": { "type": "text" },
                "publish_date": {
                    "type": "date",
                    "format": "yyyy-MM-dd HH:mm:ss || yyyy-MM-dd || epoch_millis"
                }
            }
        },
        "woman": {}
    }
}
'

# 查看索引的参数信息
curl -X GET http://localhost:9200/article/_settings
curl -X GET http://localhost:9200/article/_settings?pretty

# 索引比较重要的设置是analysis分析器，用来配置已存在的分析器或创建自定义分析器来定制化你的索引。
# standard 分析器是用于全文字段的默认分析器，对于大部分西方语言来说是一个不错的选择。它考虑了以下几点：
#   standard 分词器，在词层级上分割输入的文本。
#   standard 表征过滤器，被设计用来整理分词器触发的所有表征（但是目前什么都没做）。
#   lowercase 表征过滤器，将所有表征转换为小写。
#   stop 表征过滤器，删除所有可能会造成搜索歧义的停用词，如 a， the， and， is。
# 默认情况下，停用词过滤器是被禁用的。如需启用它，你可以通过创建一个基于standard分析器的自定义分析器，并且设置stopwords参数。可以提供一个停用词列表，或者使用一个特定语言的预定停用词列表。
# 在下面的例子中，我们创建了一个新的分词器，叫做 es_std，并使用预定义的西班牙语停用词：
curl -X PUT http://localhost:9200/title -d '
{
    "analysis" : {
        "analyzer" : {
            "es_std" : {
                "type" : "standard" ,
                "stopwords" : "_spanish"
            }
        }
    }
}
'
```

##### 同一索引下的同一doc_type可以插入文档字段结构不同的json对象，网上那些人写的博客"同一索引的同一doc_type下的文档字段结构都一样"是废话的 
```
# 插入文档时指定id的话，id是随机生成的
curl -X POST http://localhost:9200/school/student -d '{"username":"username","age":12}'
curl -X POST http://localhost:9200/school/student -d '{"username1":"username","age1":12}'
curl -X POST http://localhost:9200/school/student/1 -d '{"username":"username","age":12}'
curl -X POST http://localhost:9200/school/student/2 -d '{"username1":"username","age1":12}'
# 查看某个doc_type的文档列表
curl -X GET http://localhost:9200/school/student/_search
# 查看某个index索引的文档列表
curl -X GET http://localhost:9200/school/_search
# 查看具体id的文档
curl -X GET http://localhost:9200/school/student/1
curl -X GET http://localhost:9200/school/student/2
```

##### PUT 和 POST 都可以插入json文档，区别是
```
# PUT插入json文档时，URL必须指定id，若id存在，则覆盖当前id的json文档，该文档的版本号加1，若id不存在，则新增一个json文档
curl -X PUT http://localhost:9200/school/student/1 -d '{"username":"username","age":12}'
# 这会出错  curl -X PUT http://localhost:9200/school/student -d '{"username":"username","age":12}'
curl -X GET http://localhost:9200/school/student/1
# PUT插入json文档时，URL加不加id都可以，若URL有id且该id在es有存在的json文档，则覆盖当前id的json文档，该文档的版本号加1；若URL有id但该id记录不存在，则新增一个json文档。若URL不存在id，则插入新的json对象
curl -X POST http://localhost:9200/school/student -d '{"username":"username","age":12}'
curl -X POST http://localhost:9200/school/student -d '{"username1":"username","age1":12}'
curl -X POST http://localhost:9200/school/student/11 -d '{"username":"username","age":12}'
curl -X POST http://localhost:9200/school/student/12 -d '{"username1":"username","age1":12}'
```

##### 查询搜索文档
```
# 不装插件，只能用POST请求批量删除某个doc type的所有文档
curl -X POST http://localhost:9200/school/student/_delete_by_query?conflicts=proceed -d '{"query":{"match_all":{}}}'
curl -X POST http://localhost:9200/school/student -d '{"username":"username", "age":12}'
curl -X POST http://localhost:9200/school/student -d '{"username":"username", "age":13}'
curl -X POST http://localhost:9200/school/student -d '{"username":"username", "age":14}'
curl -X POST http://localhost:9200/school/student -d '{"username":"user name user name", "age":121}'
curl -X POST http://localhost:9200/school/student -d '{"username":"user name user name", "age":120}'
curl -X POST http://localhost:9200/school/student -d '{"username":"user name user name", "age":122}'

curl -X GET http://localhost:9200/school/student/_search -d '{"query":{"match_all":{}}}'
# {
#    "query": { "match_all": {} }
# }

# 分页搜索查询
curl -X GET http://localhost:9200/school/student/_search -d '{"from":1, "size":100}'
# {
#    "from": 0,
#    "size" 1000 
# }
curl -X GET http://localhost:9200/school/student/_search -d '{"from":1, "size":1}'
curl -X GET http://localhost:9200/school/student/_search -d '{"from":1, "size":100}'
# curl -X GET http://localhost:9200/school/student/_search -d '{"query":{"match_all":{}}, "from":1, "size":100}'
curl -X POST http://localhost:9200/school/student/_search -d '{"from":1, "size":1}'
curl -X POST http://localhost:9200/school/student/_search -d '{"from":1, "size":100}'


# 条件查询
curl -X GET http://localhost:9200/school/student/_search?pretty -d '{"query":{"match":{"username":"name"}}}'
# {
#     "query": {
#         "match": {
#             "username":"name"
#         }
#     }
# }
```

```
###  练习
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
12) 怎么集成Head插件

Elasticsearch实战系列-RESTful API使用  https://blog.csdn.net/top_code/article/details/50733257
{
    "email":      "john@smith.com",
    "first_name": "John",
    "last_name":  "Smith",
    "about": {
        "bio":         "Eco-warrior and defender of the weak",
        "age":         25,
        "interests": [ "dolphins", "whales" ]
    },
    "join_date": "2014/05/01",
}
```

##### 计算n台服务器下，shards和replicas的最优比例，保证挂了多台服务器，整个集群还可以正常运行
```
number_of_replicas : 一般是2(shards+replicas就为3了，相当于有3份数据),多则就为4(shards+replicas就为5了，相当于有5份数据)
number_of_shards: 有多少台机器就多少个shards
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
      },
      "_all": {
        "enabled": false
      }
    }
  },
  "aliases": {
    "Yaohong-plan-active": {}
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
```

##### 
```
```

##### 
```
```

##### 
```
```

##### 
```
```

##### 
```
```