# 各种restful接口命令讲解

##### 实验前的准备条件
```
docker stop single-elasticsearch
docker rm single-elasticsearch
docker network rm elasticsearch-network
docker network create --subnet=10.101.57.0/24 elasticsearch-network
docker run -itd --restart always --net elasticsearch-network --ip 10.101.57.101 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" -p 9200:9200 --name single-elasticsearch elasticsearch:5.6.10-alpine
# 访问URL http://localhost:9200
curl http://localhost:9200
```

##### elasticsearch可以直接插入数据，系统会自动建立缺失的index和doc type，并对字段建立mapping。

##### elasticsearch创建索引(创建索引时传参数和不传参数的区别)
```
# 创建索引时，不传参数不会抛异常
curl -X PUT http://localhost:9200/school
# 创建索引时，传任意json会抛错，例如  curl -X PUT http://localhost:9200/student -d ’{"username":"username","age":12}‘
# 可以通过很多种方式来自定义索引行为，Elasticsearch提供了优化好的默认配置。最重要的参数是：number_of_shards和number_of_replicas
# number_of_shards：定义一个索引的主分片个数，默认值是5。这个配置在索引创建后不能修改。
# number_of_replicas：每个主分片的复制分片个数，默认是1。这个配置可以随时在活跃的索引上修改。
# 5.6.10版本用这条命令命令创建索引，但是其他版本用这条命令创建时，会抛参数不正确的异常信息
curl -X PUT http://localhost:9200/student -d '{"number_of_shards":1, "number_of_replicas":0}'
# 通过新增一个文档让es自动创建默认索引。事实上，你可以通过在config/elasticsearch.yml 中添加下面的配置来防止自动创建索引

# 创建索引时同时设置mapping，可以配置多个doc type的mapping
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