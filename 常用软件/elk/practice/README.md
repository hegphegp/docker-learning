
#### 官方文档地址(https://www.elastic.co/guide/en/elasticsearch/reference/7.8/getting-started.html)
#### Elasticsearch7.6中文文档(https://www.kancloud.cn/yiyanan/elasticsearch_7_6/1668542)
#### 官方文档地址的asciidoc(https://github.com/elastic/elasticsearch/edit/7.8/docs/reference/sql/endpoints/rest.asciidoc)
##### 实验前的准备条件
* 因为涉及到中文分词，中文分词插件要单独配置，而且插件都是十几MB，直接去 https://gitee.com/hegp/deploy.git 拉docker-compose脚本部署环境，里面配好了中文插件


#### 常用命令
```
# 使用 _bulk 批量添加数据
curl -XPOST "localhost:9200/bank/_bulk?pretty&refresh" -H "Content-Type: application/json" --data-binary "@data/accounts.json"

curl -XGET 'localhost:9200/_cat/indices?v' -H "Content-Type: application/json"

curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}'

# 分页查询
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "query": { "match_all": {} },
    "sort": [
        { "account_number": "asc" }
    ],
    "from": 10,
    "size": 10
}'

# match 搜索 address字段包含mill或者lane的内容
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "query": { "match": { "address": "mill lane" } }
}'

# match_phrase 进行词组搜索，而不是匹配单个词，查询地址仅匹配包含短语的 mill lane 数据
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "query": { "match_phrase": { "address": "mill lane" } }
}'

# 可以使用bool组合多个查询条件。可以根据需要（必须匹配），期望（应该匹配）或不期望（必须不匹配）指定条件。
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}'


# 使用范围过滤器将结果限制为余额在20,000美元到30,000美元（含）之间的帐户
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "query": {
        "bool": {
            "must": { "match_all": {} },
            "filter": {
                "range": {
                    "balance": {
                        "gte": 20000,
                        "lte": 30000
                    }
                }
            }
        }
    }
}'

```


#### 使用汇总分析结果
```
# 使用terms汇总将bank索引中的所有帐户按状态分组，并按降序返回帐户数量最多的十个州
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "size": 0,
    "aggs": {
        "group_by_state": {
            "terms": {
                "field": "state.keyword"
            }
        }
    }
}'
# 这个buckets响应中的是state字段。doc_count表示每个州帐户数量。例如，您可以看到ID（爱达荷州）有27个帐户。因为请求setsize=0，所以响应仅包含聚合结果。


# 可以组合聚合以构建更复杂的数据汇总。例如，以下请求将一个avg聚合嵌套在先前的group_by_state聚合中，以计算每个状态的平均帐户余额。
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "size": 0,
    "aggs": {
        "group_by_state": {
            "terms": {
                "field": "state.keyword"
            },
            "aggs": {
                "average_balance": {
                    "avg": {
                        "field": "balance"
                    }
                }
            }
        }
    }
}'

# 可以通过指定terms聚合内的顺序来使用嵌套聚合的结果进行排序，而不是按计数对结果进行排序
curl -XGET 'localhost:9200/bank/_search?pretty' -H "Content-Type: application/json" -d '{
    "size": 0,
    "aggs": {
        "group_by_state": {
            "terms": {
                "field": "state.keyword",
                "order": {
                    "average_balance": "desc"
                }
            },
            "aggs": {
                "average_balance": {
                    "avg": {
                        "field": "balance"
                    }
                }
            }
        }
    }
}'

# 除了这些基本的存储桶和指标聚合外，Elasticsearch还提供了专门的聚合，用于在多个字段上操作并分析特定类型的数据，例如日期，IP地址和地理数据。您还可以将单个聚合的结果馈送到管道聚合中，以进行进一步分析。
# 聚合提供的核心分析功能可启用高级功能，例如使用机器学习来检测异常。

```

```
curl -X PUT "localhost:9200/museums?pretty" -H 'Content-Type: application/json' -d'{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_point"
      }
    }
  }
}'

curl -X POST "localhost:9200/museums/_bulk?refresh&pretty" -H 'Content-Type: application/json' -d'
{"index":{"_id":1}}
{"location": "52.374081,4.912350", "name": "NEMO Science Museum"}
{"index":{"_id":2}}
{"location": "52.369219,4.901618", "name": "Museum Het Rembrandthuis"}
{"index":{"_id":3}}
{"location": "52.371667,4.914722", "name": "Nederlands Scheepvaartmuseum"}
{"index":{"_id":4}}
{"location": "51.222900,4.405200", "name": "Letterenhuis"}
{"index":{"_id":5}}
{"location": "48.861111,2.336389", "name": "Musee du Louvre"}
{"index":{"_id":6}}
{"location": "48.860000,2.327000", "name": "Musee drsay"}
'
curl -X POST "localhost:9200/museums/_search?size=0&pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": { "name": "musee" }
  },
  "aggs": {
    "viewport": {
      "geo_bounds": {
        "field": "location",    
        "wrap_longitude": true  
      }
    }
  }
}'

```

#### 请求日志搜索例子
```
curl -X PUT "localhost:9200/my-index-000001/_bulk?refresh&pretty" -H 'Content-Type: application/json' -d'
{ "index":{ } }
{ "@timestamp": "2099-11-15T14:12:12", "http": { "request": { "method": "get" }, "response": { "bytes": 1070000, "status_code": 200 }, "version": "1.1" }, "message": "GET /search HTTP/1.1 200 1070000", "source": { "ip": "127.0.0.1" }, "user": { "id": "kimchy" } }
{ "index":{ } }
{ "@timestamp": "2099-11-15T14:12:12", "http": { "request": { "method": "get" }, "response": { "bytes": 1070000, "status_code": 200 }, "version": "1.1" }, "message": "GET /search HTTP/1.1 200 1070000", "source": { "ip": "10.42.42.42" }, "user": { "id": "elkbee" } }
{ "index":{ } }
{ "@timestamp": "2099-11-15T14:12:12", "http": { "request": { "method": "get" }, "response": { "bytes": 1070000, "status_code": 200 }, "version": "1.1" }, "message": "GET /search HTTP/1.1 200 1070000", "source": { "ip": "10.42.42.42" }, "user": { "id": "elkbee" } }
'

# 下面两个curl命令是等级的
curl -X GET "localhost:9200/my-index-000001/_search?q=user.id:kimchy&pretty"

curl -X GET "localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/my-index-000001,my-index-000002/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/user_logs*/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/_all/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/*/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -XGET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'{
  "_source": false,
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'{
  "_source": "obj.*",
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'{
  "_source": [ "obj1.*", "obj2.*" ],
  "query": {
    "match": {
      "user.id": "kimchy"
    }
  }
}'

curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'{
  "_source": {
    "includes": [ "obj1.*", "obj2.*" ],
    "excludes": [ "*.description" ]
  },
  "query": {
    "term": {
      "user.id": "kimchy"
    }
  }
}'


curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'{
  "query": {
    "match_all": {}
  },
  "docvalue_fields": [
    "my_ip*",                     
    {
      "field": "my_keyword_field" 
    },
    {
      "field": "*_date_field",
      "format": "epoch_millis"    
    }
  ]
}'

```

#### SQL查询
```
curl -X PUT "localhost:9200/library/book/_bulk?refresh&pretty" -H 'Content-Type: application/json' -d'
{"index":{"_id": "Leviathan Wakes"}}
{"name": "Leviathan Wakes", "author": "James S.A. Corey", "release_date": "2011-06-02", "page_count": 561}
{"index":{"_id": "Hyperion"}}
{"name": "Hyperion", "author": "Dan Simmons", "release_date": "1989-05-26", "page_count": 482}
{"index":{"_id": "Dune"}}
{"name": "Dune", "author": "Frank Herbert", "release_date": "1965-06-01", "page_count": 604}
'


curl -X POST "localhost:9200/_sql?format=txt&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library WHERE release_date < '2000-01-01'"
}'

curl -X POST "localhost:9200/_sql?format=txt&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library WHERE page_count > 500 ORDER BY page_count DESC"
}'

curl -X POST "localhost:9200/_sql?format=txt&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library ORDER BY page_count DESC LIMIT 5"
}'

curl -X POST "localhost:9200/_sql?format=csv&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library ORDER BY page_count DESC",
  "fetch_size": 5
}'

curl -X POST "localhost:9200/_sql?format=json&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library ORDER BY page_count DESC",
  "fetch_size": 5
}'

curl -X POST "localhost:9200/_sql?format=tsv&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library ORDER BY page_count DESC",
  "fetch_size": 5
}'


curl -X POST "localhost:9200/_sql?format=txt&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library ORDER BY page_count DESC",
  "fetch_size": 5
}'

curl -X POST "localhost:9200/_sql?format=yaml&pretty" -H 'Content-Type: application/json' -d'{
  "query": "SELECT * FROM library ORDER BY page_count DESC",
  "fetch_size": 5
}'

```