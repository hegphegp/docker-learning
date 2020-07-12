#### 关于 Sorted Sets 存储排序集合
* Sorted Sets是通过Skip List(跳跃表)和hash Table(哈希表)的双端口数据结构实现的，因此每次添加元素时，Redis都会执行O(log(N))操作。所以当我们要求排序的时候，Redis早已经全部排好序了。元素的分数可以随时更新。
```java
    @Autowired
    private StringRedisTemplate redisTemplate;
    public static final String SCORE_RANK = "score_rank";

    /** 批量新增 */
    @Test
    public void batchAdd() {
        Set<ZSetOperations.TypedTuple<String>> tuples = new HashSet<>();
        for (int i = 0; i < 100000; i++) {
            tuples.add(new DefaultTypedTuple<>("张三" + i, 1D + i));
        }
        Long num = redisTemplate.opsForZSet().add(SCORE_RANK, tuples);
        System.out.println("受影响行数：" + num);
    }

    /** 获取排行列表(根据分数降序) */
    public void list() {
        Set<String> range = redisTemplate.opsForZSet().reverseRange(SCORE_RANK, 0, 5);
        System.out.println(range); // 输出 ["张三99999","张三99998","张三99997","张三99996","张三99995"]
        Set<ZSetOperations.TypedTuple<String>> data = redisTemplate.opsForZSet().reverseRangeWithScores(SCORE_RANK, 0, 2);
        System.out.println("获取到的排行和分数列表:" + JSON.toJSONString(data));
        // 获取到的排行和分数列表:[{"score":100000.0,"value":"张三99999"},{"score":99999.0,"value":"张三99998"}]
    }

    /** 单个新增，新增一个李四，分数是8899 */
    public void add() {
        redisTemplate.opsForZSet().add(SCORE_RANK, "李四", 8899);
    }

    /** 获取单个的排行 */
    public void find(){
        Long rankNum = redisTemplate.opsForZSet().reverseRank(SCORE_RANK, "李四");
        System.out.println("李四的个人排名：" + rankNum); // 李四的个人排名：91101
        Double score = redisTemplate.opsForZSet().score(SCORE_RANK, "李四");
        System.out.println("李四的分数:" + score); // 李四的分数:8899.0
    }

    /** 统计两个分数之间的人数 */
    public void count(){
        Long count = redisTemplate.opsForZSet().count(SCORE_RANK, 8001, 9000);
        System.out.println("统计8001-9000之间的人数:" + count);  // 集合的基数为：100001
    }

    /** 使用加法操作分数，增加权重 */
    public void incrementScore(){
        Double score = redisTemplate.opsForZSet().incrementScore(SCORE_RANK, "李四", 1000);
        System.out.println("李四分数+1000后：" + score); // 李四分数+1000后：9899.0
    }

    /** 删除 **/
    //通过key/value删除
    Long remove(K key, Object... values);

    //通过排名区间删除
    Long removeRange(K key, long start, long end);

    //通过分数区间删除
    Long removeRangeByScore(K key, double min, double max);

    /** 查询 **/
    //通过排名区间获取列表值集合
    Set<V> range(K key, long start, long end);

    //通过排名区间获取列表值和分数集合
    Set<TypedTuple<V>> rangeWithScores(K key, long start, long end);

    //通过分数区间获取列表值集合
    Set<V> rangeByScore(K key, double min, double max);

    //通过分数区间获取列表值和分数集合
    Set<TypedTuple<V>> rangeByScoreWithScores(K key, double min, double max);

    //通过Range对象删选再获取集合排行
    Set<V> rangeByLex(K key, Range range);

    //通过Range对象删选再获取limit数量的集合排行
    Set<V> rangeByLex(K key, Range range, Limit limit);

    //获取对象的排行
    Long rank(K key, Object o);

    //获取对象的分数
    Double score(K key, Object o);

    //统计分数区间的数量
    Long count(K key, double min, double max);

    //统计集合基数
    Long zCard(K key);
```