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