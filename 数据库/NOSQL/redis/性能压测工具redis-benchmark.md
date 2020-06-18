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

#### 插入大量数据, 以后数据迁移会用到
```
## shell脚本输出大量redis的set命令
tee create-redis.sh <<-'EOF'
#!/bin/sh

rm -rf redis-data.txt
for i in `seq 1 1000000`
do
  echo "set name$i helloworld$i" >> redis-data.txt
done
EOF

chmod a+x create-redis.sh

sh create-redis.sh

## 通过redis-cli的pipeline插入大量数据, 性能比较高, 可以达到每秒十万条数据的插入
cat redis-data.txt | redis-cli -a 密码 --pipe

## redis没有根据key前缀批量删除的功能, 下面的命令是目前比较好的批量删除数据的命令, 网上搜索的很多命令有问题, 会提示删除的keys过多, 无法删除
redis-cli -a 密码 --scan --pattern "name*" | xargs redis-cli -a 密码 del
```