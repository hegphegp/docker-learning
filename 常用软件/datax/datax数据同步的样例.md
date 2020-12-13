
### mysql增量同步，writeMode的update增量同步方式
```
{
  "job": {
    "setting": {
      "speed": {
        "channel": 1
      }
    },
    "content": [{
      "reader": {
        "name": "mysqlreader",
        "parameter": {
          "username": "",
          "password": "",
          "connection": [{
            "querySql": [
              "SELECT id,username,password,UNIX_TIMESTAMP(create_at) as create_at FROM sys_user where create_at > '${start_time}' and create_at < '${end_time}';"
            ],
            "jdbcUrl": [
              "jdbc:mysql://192.168.12.41:3306/ezp-pay?useUnicode=true&characterEncoding=utf8",
              "jdbc:mysql://192.168.12.42:3306/ezp-pay?useUnicode=true&characterEncoding=utf8"
            ]
          }]
        }
      },
      "writer": {
        "name": "mysqlwriter",
        "parameter": {
          "writeMode": "update", // 写入模式可以选择insert/replace/update，全量导入用insert，增量导入用update，但是Oracle等数据库原生不支持on duplicate key update语句，所以有些数据库太菜鸡了
          "username": "",
          "password": "",
          "dateFormat": "YYYY-MM-dd hh:mm:ss", // 不用，自己没经过无数的测试，不知道数据库内部时间转换是什么格式，什么时区
          "column": [
            "id",
            "username",
            "password",
            "create_at"
          ],
          "connection": [{
            "jdbcUrl": "jdbc:mysql://127.0.0.1:3306/ezp-pay?useUnicode=true&characterEncoding=utf8",
            "table": [
              "sys_user"
            ]
          }]
        }
      }
    }]
  }
}

python bin/datax.py /home/hgp/mysql2mysql.json -p "-Dstart_time='2018-06-17 00:00:00' -Dend_time='2018-06-18 23:59:59'"
```