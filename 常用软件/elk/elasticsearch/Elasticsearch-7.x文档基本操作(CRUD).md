## Elasticsearch-7.x文档基本操作(CRUD)

* term应用在不可分割字段上，match对text类型字段模糊查询

#### docker搭建服务
```
docker pull elasticsearch:7.8.0

docker stop elasticsearch
docker rm elasticsearch
docker run -itd --restart always -p 9200:9200 -p 9300:9300 -e ES_JAVA_OPTS="-Xms256m -Xmx512m" -e "discovery.type=single-node" --name elasticsearch elasticsearch:7.7.1
docker logs -f --tail=300 elasticsearch
```

#### 指定文档ID添加文档或者更新文档
```
curl -XPUT localhost:9200/blog/_doc/1?pretty -H 'content-Type:application/json' -d '{
    "title":"1、VMware Workstation虚拟机软件安装图解",
    "author":"chengyuqiang",
    "content":"1、VMware Workstation虚拟机软件安装图解...",
    "url":"http://x.co/6nc81"
}'
```

#### 不指定文档ID，添加文档，每次都创建新的文档
```
curl -XPOST localhost:9200/blog/_doc?pretty -H 'content-Type:application/json' -d '{
    "title":"2、Linux服务器安装图解",
    "author":"chengyuqiang",
    "content":"2、Linux服务器安装图解解...",
    "url":"http://x.co/6nc82"
}'
```

#### 根据指定文档ID查看文档
```
curl -XGET localhost:9200/blog/_doc/1?pretty
```

#### 根据指定文档ID查看不存在的文档
```
curl -XGET localhost:9200/blog/_doc/189?pretty
```

#### 更改id为1的文档，删除了author，修改content字段
```
curl -XPUT localhost:9200/blog/_doc/1?pretty -H 'content-Type:application/json' -d '{
    "title":"1、VMware Workstation虚拟机软件安装图解",
    "content":"下载得到VMware-workstation-full-15.0.2-10952284.exe可执行文件...",
    "url":"http://x.co/6nc81"
}'
```

#### 根据指定文档ID查看文档
```
curl -XGET localhost:9200/blog/_doc/1?pretty
```

#### 添加文档时，防止覆盖已存在的文档，可以通过_create加以限制。该文档已经存在，添加失败。
```
curl -XPUT localhost:9200/blog/_doc/1/_create?pretty -H 'content-Type:application/json' -d '{
    "title":"1、VMware Workstation虚拟机软件安装图解",
    "content":"下载得到VMware-workstation-full-15.0.2-10952284.exe可执行文件...",
    "url":"http://x.co/6nc81"
}'
```

#### 更新文档的某个字段，通过脚本更新制定字段，其中ctx是脚本语言中的一个执行对象，先获取_source，再修改content字段
```
curl -XPOST localhost:9200/blog/_doc/1/_update?pretty -H 'content-Type:application/json' -d '{
    "script": {
        "source": "ctx._source.content=\"修改后的内容\""
    }
}'
```

#### 根据指定文档ID查看文档
```
curl -XGET localhost:9200/blog/_doc/1?pretty
```

#### 添加字段，通过脚本添加字段，其中ctx是脚本语言中的一个执行对象，先获取_source，再添加字段
```
curl -XPOST localhost:9200/blog/_doc/1/_update?pretty -H 'content-Type:application/json' -d '{
    "script": {
        "source": "ctx._source.newField=\"new-field-data\""
    }
}'
```

#### 删除字段，通过脚本添加字段，其中ctx是脚本语言中的一个执行对象，先获取_source，再删除字段
```
curl -XPOST localhost:9200/blog/_doc/1/_update?pretty -H 'content-Type:application/json' -d '{
    "script": {
        "source": "ctx._source.remove(\"newField\")"
    }
}'
```

#### 删除文档
```
curl -XDELETE localhost:9200/blog/_doc/1?pretty
```

#### 批量操作，es提供了Bulk API，可以批量索引、删除、更新等操作，可以在单个请求进行多次 create、 index、 update 或 delete 操作。每行一定要以换行符(\n)结尾， 包括最后一行 。bulk请求格式如下：
```
{ action: { metadata }}\n
{ request body        }\n
{ action: { metadata }}\n
{ request body        }\n
...
```

* 批量新增
```
curl -XPOST localhost:9200/_bulk?pretty -H 'content-Type:application/json' -d '
    { "create": { "_index": "blog", "_type": "_doc", "_id": "1" }}
    { "title": "1、VMware Workstation虚拟机软件安装图解" ,"author":"chengyuqiang","content":"官网下载VMware-workstation，双击可执行文件进行安装" , "url":"http://x.co/6nc81" }
    { "create": { "_index": "blog", "_type": "_doc", "_id": "2" }}
    { "title":  "2、Linux服务器安装图解" ,"author":  "chengyuqiang" ,"content": "VMware模拟Linux服务器安装图解" , "url": "http://x.co/6nc82" }
    { "create": { "_index": "blog", "_type": "_doc", "_id": "3" }}
    { "title":  "3、Xshell 6 个人版安装与远程操作连接服务器" , "author": "chengyuqiang" ,"content": "Xshell 6 个人版安装与远程操作连接服务器..." , "url": "http://x.co/6nc84" }
'
```

* 批量操作，包括删除、更新、新增
```
curl -XPOST localhost:9200/_bulk?pretty -H 'content-Type:application/json' -d '
    { "delete": { "_index": "blog", "_type": "_doc", "_id": "1" }}
    { "update": { "_index": "blog", "_type": "_doc", "_id": "3", "retry_on_conflict" : 3} }
    { "doc" : {"title" : "Xshell教程"} }
    { "index": { "_index": "blog", "_type": "_doc", "_id": "4" }}
    { "title": "4、CentOS 7.x基本设置" ,"author":"chengyuqiang","content":"CentOS 7.x基本设置","url":"http://x.co/6nc85" }
    { "create": { "_index": "blog", "_type": "_doc", "_id": "5" }}
    { "title": "5、图解Linux下JDK安装与环境变量配置","author":"chengyuqiang" ,"content": "图解JDK安装配置" , "url": "http://x.co/6nc86" }
'
```

* 根据id集合批量操作
```
curl -XGET localhost:9200/blog/_doc/_mget?pretty -H 'content-Type:application/json' -d '{
    "ids" : ["1", "2","3"]
}'
```

#### 指定分片数和副本数
```
curl -XPUT localhost:9200/website?pretty -H 'content-Type:application/json' -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 1,
            "number_of_replicas" : 1
        }
    }
}'
```

#### 要创建一个新的具有外部版本号 5 的博客文章，URL要用双引号括起来，否则在下面这条语句会抛错
```
curl -XPUT "localhost:9200/website/_doc/5?pretty&version=5&version_type=external" -H 'content-Type:application/json' -d '{
    "title": "My first external blog entry",
    "text":  "Starting to get the hang of this..."
}'
```

#### 简单搜索，词项查询，也称term查询
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "term": {
            "title": "centos"
        }
    }
}'
```

#### 匹配查询，也称match查询，与term精确查询不同，对于match查询，只要被查询字段中存在任何一个词项被匹配，就会搜索到该文档。
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "match": {
            "title": "远程"
        }
    }
}'
```

#### 准确匹配“菜谱入门”则用match_phrase
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "match_phrase": {
            "title": "远程"
        }
    }
}'
```

#### 多个字段匹配查询
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "multi_match": {
            "query": "远程",
            "fields":["author","title"]
        }
    }
}'
```

#### query_string 既查有“办公”又有“娱乐”的数据
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "query_string": {
            "query": "办公 AND 娱乐"
        }
    }
}'
```

#### query_string 匹配“办公”AND "娱乐" 或者匹配“菜谱”
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "query_string": {
            "query": "(办公 AND 娱乐) OR 菜谱"
        }
    }
}'
```

#### 指定context和song字段，查询"办公"或“娱乐”
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "query_string": {
            "query": "办公 OR 娱乐",
            "fields":["context","author"]
        }
    }
}'
```

#### 按照范围查询，查询书籍字段在2000到5000的数据有哪些
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "range": {
            "word_count": {
                "gte":2000,
                "lte":5000
            }
        }
    }
}'
```

#### 子条件查询中的Filter context
```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "bool": {
            "filter": {
                "term": {
                    "word_count":2000
                }
            }
        }
    }
}'
```

```
curl -XGET localhost:9200/blog/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "bool": {
            "filter": {
                "term": {
                    "title": "办公"
                }
            }
        }
    }
}'
```

#### 综合query和filter的符合条件查询，复合查询有： 固定分数查询、布尔查询等等
```
# 从根路径全文检索，从 localhost:9200/_search 根路径进行全文检索
# 指定 score 分数大于2的查询
curl -XGET localhost:9200/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "constant_score": {
            "filter": {
                "match": {
                    "title": "办公"
                }
            },
            "boost":2
        }
    }
}'
```


#### 布尔查询，关键词should 匹配中match条件的一种即返回数据，是或的关系
```
curl -XGET localhost:9200/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "bool": {
            "should": [
                {
                    "match": {
                        "title": "办公"
                    }
                },
                {
                    "match": {
                        "content": "娱乐"
                    }
                }
            ]
        }
    }
}'
```

#### 布尔查询还有一个 must关键词，即两条必须同时满足，是与的关系
```
curl -XGET localhost:9200/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "title": "办公"
                    }
                }, {
                    "match": {
                        "content": "娱乐"
                    }
                }
            ]
        }
    }
}'
```

#### must还可以和filter进行组合
```
curl -XGET localhost:9200/_search?pretty -H 'content-Type:application/json' -d '{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "title": "办公"
                    }
                }, {
                    "match": {
                        "content": "娱乐"
                    }
                }
            ],
            "filter": [
                {
                    "term": {
                        "word_count": 2000
                    }
                }, {
                    "match": {
                        "publish_date":"2018-09-09"
                    }
                }
            ]
        }
    }
}'
```

```
curl -XGET localhost:9200/_search?pretty -H 'content-Type:application/json' -d '{
    "size": 10,
    "query": {
        "bool": {
            "should": [{
                    "match": {
                        "content": "要搜索的内容"
                    }
                },
                {
                    "match": {
                        "title": "要搜搜索的标题"
                    }
                }
            ]
        }
    },
    "highlight": {
        "fields": {
            "title": {},
            "content": {
                "type": "plain"
            }
        }
    }
}'


```