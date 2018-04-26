## Redis命令

[Redis配置参数详解http://www.runoob.com/redis/redis-conf.html](http://www.runoob.com/redis/redis-conf.html)

#### Redis五种数据类型：string(字符串),hash(哈希),list(列表),set(集合)及zset(sorted set：有序集合)
##### string(字符串)类型
```shell
SET mykey "runoob"
GET mykey
DEL mykey
```

##### hash(哈希)
> Redis hash 是一个键值(key=>value)对集合
```
HMSET myhash field1 "Hello" field2 "World"
HGET myhash field1
HGET myhash field2
HMSET myhash field3 "field3"
HGET myhash field3
HMSET myhash field2 "field2"
HGET myhash field2
# 获取指定hash的所有key : HKEYS 要查询的hash名称
HKEYS myhash
# 获取指定hash的所有value : HVALS 要查询的hash名称
HVALS myhash
# 查询hash的大小 : HLEN 要查询的hash名称
HLEN myhash
```

##### list(列表)
> Redis 列表是简单的字符串列表，按照插入顺序排序
```shell
lpush mylist redis
lpush mylist mongodb
lpush mylist rabitmq
lrange mylist 0 10
# 获取列表长度 : LLEN 要查询的list名称 
LLEN mylist
```
> Redis的List命令里没有根据index删除元素的命令，但有的时候业务会需要这个功能
```
LSET KEY的名称 index "__deleted__"
LREM KEY的名称 0 "__deleted__"
```

##### set(集合)
> Redis的Set是string类型的无序集合。集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。
```shell
sadd myset redis
sadd myset mongodb
sadd myset rabitmq
sadd myset rabitmq
smembers myset
# 查询set集合元素的数量 : SCARD set集合的名称
SCARD myset
# 删除set集合的一个或者多个元素 : SREM key member1 [member2]
SREM myset redis
SREM myset mongodb rabitmq
```

##### zset(sorted set：有序集合)
> Redis zset 和 set 一样是string类型的集合。zset的每个元素会关联一个double类型的分数。  
> redis正是通过分数来为集合中的成员进行从小到大的排序。zset的成员是唯一的,但分数(score)却可以重复。  
> 命令格式  zadd key score member
```shell
zadd myzset 0 redis
zadd myzset 0 mongodb
zadd myzset 0 rabitmq
zadd myzset 0 rabitmq
ZRANGEBYSCORE myzset 0 1000
# 查询zset集合元素的数量 : ZCARD zset集合的名称
ZCARD myzset
```

##### 查看key的命令
> 查找所有符合给定模式的key命令 : KEYS PATTERN
```
KEYS a
KEYS *a
KEYS *a*
```


```shell
docker run -itd --restart always --name study-redis -p 16379:6379 redis
docker exec -it study-redis sh
# redis-cli -h ip -p port
# redis-cli -h ip -p port -a password
redis-cli -h localhost -p 6379
```
