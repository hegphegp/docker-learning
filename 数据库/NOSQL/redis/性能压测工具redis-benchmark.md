# Redis性能压测工具 redis-benchmark 

##### [参考博客https://blog.csdn.net/zlfprogram/article/details/74338685](https://blog.csdn.net/zlfprogram/article/details/74338685)
```
redis-benchmark -q -n 100000
redis-benchmark -t set,lpush -n 100000 -q
redis-benchmark -n 100000 -q script load "redis.call('set','foo','bar')"
redis-cli flushall
redis-benchmark -t set -r 100000 -n 1000000
redis-cli dbsize
redis-benchmark -n 1000000 -t set,get -P 16 -q
redis-benchmark -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q
redis-benchmark -r 1000000 -n 2000000 -t get,set,lpush,lpop -q
redis-benchmark -r 1000000 -n 2000000 -t get,set,lpush,lpop -q -P 16
redis-benchmark -r 1000000 -n 2000000 -t get,set,lpush,lpop -q
redis-benchmark -n 100000
redis-benchmark -q -n 100000
redis-benchmark -q -n 100000 -d 256
```

#### 插入大量数据, 以后测试大量模拟数据时，测试在线迁移大量数据时会用到
```
## redis-cli可以读取文本文件下面格式的数据录入
set myk12 v1
zadd zset12 0 a 1 b 3 c
sadd sset12 e f g hh
hset myset12 k1 v1
hmset myset22 k2 v2 k3 v3 k4 v4
```

```
## shell脚本输出大量redis的set命令
tee insert-redis-data.sh <<-'EOF'
#!/bin/sh

rm -rf redis-data.txt
for i in `seq 1 1000000`
do
  echo "set test:insert:set$i value" >> redis-data.txt
  echo "zadd test:insert:zset$i 0 value0 1 value1 2 value2" >> redis-data.txt
  echo "sadd test:insert:sset$i value0 value1 value2" >> redis-data.txt
  echo "hset test:insert:hset$i key1 value1 key2 value2" >> redis-data.txt
  echo "hmset test:insert:hmset$i key1 value1 key2 value2" >> redis-data.txt
done
EOF

chmod a+x insert-redis-data.sh

sh insert-redis-data.sh

## 通过redis-cli的pipeline插入大量数据, 性能比较高, 可以达到每秒十万条数据的插入
cat redis-data.txt | redis-cli -a 密码 --pipe

## 查看key的数量
redis-cli -a 密码 info keyspace

## redis没有根据key前缀批量删除的功能, 下面的命令是目前比较好的批量删除数据的命令, 网上搜索的很多命令有问题, 会提示删除的keys过多, 无法删除
redis-cli -a 密码 --scan --pattern "name*" | xargs redis-cli -a 密码 del --pipe
```

```
## shell脚本输出大量redis的set命令
tee insert-redis-data.sh <<-'EOF'
#!/bin/sh

rm -rf redis-data.txt
for i in `seq 1 1000000`
do
  echo "set test:insert:set$i value$i" >> redis-data.txt
  echo "zadd test:insert:zset$i 0 value0$i 1 value1$i 2 value2$i" >> redis-data.txt
  echo "sadd test:insert:sset$i value0$i value1$i value2$i" >> redis-data.txt
  echo "hset test:insert:hset$i key1 value1$i key2 value2$i" >> redis-data.txt
  echo "hmset test:insert:hmset$i key1 value1$i key2 value2$i" >> redis-data.txt
done
EOF

chmod a+x insert-redis-data.sh

sh insert-redis-data.sh

## 通过redis-cli的pipeline插入大量数据, 性能比较高, 可以达到每秒十万条数据的插入
cat redis-data.txt | redis-cli -a 密码 --pipe

## 查看key的数量
redis-cli -a 密码 info keyspace

## redis没有根据key前缀批量删除的功能, 下面的命令是目前比较好的批量删除数据的命令, 网上搜索的很多命令有问题, 会提示删除的keys过多, 无法删除
redis-cli -a 密码 --scan --pattern "name*" | xargs redis-cli -a 密码 del --pipe
```