# Redis-trib的常用命令

```
01) create      : 创建集群
02) check       : 检查集群
03) info        : 查看集群信息
04) fix         : 修复集群
05) reshard     : 在线迁移slot
06) rebalance   : 平衡集群节点slot数量
07) add-node    : 将新节点加入集群
08) del-node    : 从集群中删除节点
09) set-timeout : 设置集群节点间心跳连接的超时时间
10) call        : 在集群全部节点上执行命令
11) import      : 将外部redis数据导入集群
```

```
redis-trib.rb create --replicas 1 10.10.57.101:6379 10.10.57.102:6379 10.10.57.103:6379 10.10.57.104:6379 10.10.57.105:6379 10.10.57.106:6379 

创建流程如下：
1) 首先为每个节点创建ClusterNode对象，包括连接每个节点。检查每个节点是否为独立且db为空的节点。执行load_info方法导入节点信息。
2) 检查传入的master节点数量是否大于等于3个。只有大于3个节点才能组成集群。
3) 计算每个master需要分配的slot数量，以及给master分配slave。分配的算法大致如下：
   3.1) 不停遍历遍历host列表，从每个host列表中弹出一个节点，放入interleaved数组。直到所有的节点都弹出为止。
   3.2) master节点列表就是interleaved前面的master数量的节点列表。保存在masters数组。
   3.3) 计算每个master节点负责的slot数量，保存在slots_per_node对象，用slot总数除以master数量取整即可。
   3.4) 遍历masters数组，每个master分配slots_per_node个slot，最后一个master，分配到16384个slot为止。
   3.5) 接下来为master分配slave，分配算法会尽量保证master和slave节点不在同一台主机上。对于分配完指定slave数量的节点，还有多余的节点，也会为这些节点寻找master。分配算法会遍历两次masters数组。
   3.6) 第一次遍历masters数组，在余下的节点列表找到replicas数量个slave。每个slave为第一个和master节点host不一样的节点，如果没有不一样的节点，则直接取出余下列表的第一个节点。
   3.7) 第二次遍历是在对于节点数除以replicas不为整数，则会多余一部分节点。遍历的方式跟第一次一样，只是第一次会一次性给master分配replicas数量个slave，而第二次遍历只分配一个，直到余下的节点被全部分配出去。
4) 打印出分配信息，并提示用户输入“yes”确认是否按照打印出来的分配方式创建集群。
5) 输入“yes”后，会执行flush_nodes_config操作，该操作执行前面的分配结果，给master分配slot，让slave复制master，对于还没有握手（cluster meet）的节点，slave复制操作无法完成，不过没关系，flush_nodes_config操作出现异常会很快返回，后续握手后会再次执行flush_nodes_config。
6) 给每个节点分配epoch，遍历节点，每个节点分配的epoch比之前节点大1。
7) 节点间开始相互握手，握手的方式为节点列表的其他节点跟第一个节点握手。
8) 然后每隔1秒检查一次各个节点是否已经消息同步完成，使用ClusterNode的get_config_signature方法，检查的算法为获取每个节点cluster nodes信息，排序每个节点，组装成node_id1:slots|node_id2:slot2|...的字符串。如果每个节点获得字符串都相同，即认为握手成功。
9) 此后会再执行一次flush_nodes_config，这次主要是为了完成slave复制操作。
10) 最后再执行check_cluster，全面检查一次集群状态。包括和前面握手时检查一样的方式再检查一遍。确认没有迁移的节点。确认所有的slot都被分配出去了。
11) 至此完成了整个创建流程，返回[OK] All 16384 slots covered.。
```