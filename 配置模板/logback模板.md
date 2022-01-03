## logback.xml的配置样例，这个样例配置了下面参数
* 根路径配置日志级别为info(或者debug)，只能绑定ConsoleAppender，这样子保证只在控制台输出，不会在服务器日志文件输出
* 服务器配置 debbug，info，error级别的日志
    * info级别，error级别的日志文件，只输出对应等级(即info日志配置不要输出error等级)
    * debbug级别，不配置 LevelFilter，输出所有等级的日志
    * debbug日志，只保存 2 天
* 如果设置了logback.xml文件
    * 必须要设置consoleAppender，且只有 springProfile=local 才可以启用，否则控制台不会打印日志
    * 如果其他环境 springProfile 也设置了consoleAppender，在服务器执行jar -jar时，会输出所有控制台日志，同时严重影响90%的性能，因为执行完java -jar命令后，控制台日志是同步输出

```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false">
    <property name="log.path" value="/data/logs/a-service"></property>

    <appender name="consoleAppender" class="ch.qos.logback.core.ConsoleAppender">
        <layout class="ch.qos.logback.classic.PatternLayout">
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} [%file:%line] - %msg%n</Pattern>
        </layout>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>DEBUG</level>
        </filter>
    </appender>

    <!-- 按日期和大小区分的滚动日志 -->
    <appender name="debugLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 必须指定，否则不会往文件输出内容 -->
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
            <charset>UTF-8</charset>
        </encoder>
        <!-- 必需要指定rollingPolicy 与 triggeringPolicy 属性 否则不会生成文件-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 后缀名为.log不会压缩分割后的文件，只有后缀名为.gz或者.zip -->
            <fileNamePattern>${log.path}/debug.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
            <!-- DEBUG日志文件最多保存1天 -->
            <maxHistory>1</maxHistory>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <!--文件达到最大500MB时会被切割 -->
                <maxFileSize>500MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>DEBUG</level>
        </filter>
    </appender>

    <!-- 按日期和大小区分的滚动日志 -->
    <appender name="infoLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
            <charset>UTF-8</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 后缀名为.log不会压缩分割后的文件，只有后缀名为.gz或者.zip -->
            <fileNamePattern>${log.path}/info.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
            <cleanHistoryOnStart>true</cleanHistoryOnStart>
            <!-- 日志文件最大的保存天数-->
            <maxHistory>30</maxHistory>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <!--文件达到最大500MB时会被切割 -->
                <maxFileSize>500MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 只输出INFO级别日志，WARN，ERROR级别不输出 -->
            <level>INFO</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <!-- 按日期和大小区分的滚动日志 -->
    <appender name="warnLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
            <charset>UTF-8</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 后缀名为.log不会压缩分割后的文件，只有后缀名为.gz或者.zip -->
            <fileNamePattern>${log.path}/warn.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
            <cleanHistoryOnStart>true</cleanHistoryOnStart>
            <!-- 日志文件最大的保存天数-->
            <maxHistory>30</maxHistory>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <!--文件达到最大500MB时会被切割 -->
                <maxFileSize>500MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 只输出WARN级别日志，ERROR级别不输出 -->
            <level>WARN</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <!-- error级别只按日期滚动生成日志 -->
    <appender name="errorLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 必须指定，否则不会往文件输出内容 -->
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
            <charset>UTF-8</charset>
        </encoder>
        <!-- 必需要指定rollingPolicy 与 triggeringPolicy 属性   否则不会生成文件-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 后缀名为.log不会压缩分割后的文件，只有后缀名为.gz或者.zip -->
            <fileNamePattern>${log.path}/error.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
            <cleanHistoryOnStart>true</cleanHistoryOnStart>
            <!-- 日志文件最大的保存天数-->
            <maxHistory>30</maxHistory>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <!--文件达到 最大500MB时会被切割 -->
                <maxFileSize>500MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 只输出ERROR级别日志 -->
            <level>ERROR</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <!-- 只有local环境，才可以输出控制台信息，否则在服务器执行 jar -jar 命令，会输出所有控制台日志，严重影响性能 -->
    <!-- <springProfile name="local,test"> -->
    <springProfile name="local">
        <root level="DEBUG">
            <appender-ref ref="consoleAppender" />
        </root>
    </springProfile>

    <logger name="tech.codingfly" level="INFO">
        <appender-ref ref="debugLog" />
        <appender-ref ref="infoLog" />
        <appender-ref ref="warnLog" />
        <appender-ref ref="errorLog" />
    </logger>

</configuration>
```


#### 配置不同环境下日志打印的配置
```xml
    <springProfile name="local,test">
        <root level="DEBUG">
            <appender-ref ref="consoleAppender" />
        </root>
    </springProfile>
```
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- debug：是否打印日志插件的日志 -->
<configuration scan="true" scanPeriod="60 seconds" debug="false">

    <!-- 文件输出格式 -->
    <property name="PATTERN" value="%-12(%d{yyyy-MM-dd HH:mm:ss.SSS}) |-%-5level [%thread] %c [%L] -| %msg%n" />
    <!-- test文件路径 -->
    <property name="TEST_FILE_PATH" value="c:/opt/roncoo/logs" />
    <!-- pro文件路径 -->
    <property name="PRO_FILE_PATH" value="/opt/roncoo/logs" />

    <!-- 开发环境 -->
    <springProfile name="dev">
        <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>${PATTERN}</pattern>
                <charset>UTF-8</charset>
            </encoder>
        </appender>
        
        <logger name="com.roncoo.education" level="debug"/>
        <logger name="org.springframework.jdbc.core.JdbcTemplate" level="debug"/>
        <logger name="org.springframework.data.mongodb.core.MongoTemplate" level="debug"/>

        <root level="info">
            <appender-ref ref="CONSOLE" />
        </root>
    </springProfile>

    <!-- 测试环境 -->
    <springProfile name="test">
        <!-- 每天产生一个文件 -->
        <appender name="TEST-FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <!-- 文件路径 -->
            <file>${TEST_FILE_PATH}</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <!-- 文件名称 -->
                <fileNamePattern>${TEST_FILE_PATH}/info.%d{yyyy-MM-dd}.log</fileNamePattern>
                <!-- 文件最大保存历史数量 -->
                <MaxHistory>100</MaxHistory>
            </rollingPolicy>
            <layout class="ch.qos.logback.classic.PatternLayout">
                <pattern>${PATTERN}</pattern>
            </layout>
        </appender>
        
        <root level="info">
            <appender-ref ref="TEST-FILE" />
        </root>
    </springProfile>

    <!-- 生产环境 -->
    <springProfile name="prod">
        <appender name="PROD_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>${PRO_FILE_PATH}</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>${PRO_FILE_PATH}/warn.%d{yyyy-MM-dd}.log</fileNamePattern>
                <MaxHistory>100</MaxHistory>
            </rollingPolicy>
            <layout class="ch.qos.logback.classic.PatternLayout">
                <pattern>${PATTERN}</pattern>
            </layout>
        </appender>
        
        <root level="warn">
            <appender-ref ref="PROD_FILE" />
        </root>
    </springProfile>
</configuration>
```

### 设置根目录的日志级别，已经根目录对应的appender
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true" scanPeriod="60 seconds" debug="false">
    <root level="warn">
        <appender-ref ref="PROD_FILE" />
    </root>
</configuration>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true" scanPeriod="60 seconds" debug="false">

    <contextName>logback-demo</contextName>

    <!--输出到控制台 ConsoleAppender-->
    <appender name="consoleLog" class="ch.qos.logback.core.ConsoleAppender">
        <!--展示格式 layout-->
        <layout class="ch.qos.logback.classic.PatternLayout">
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
        </layout>
    </appender>

    <appender name="fileInfoLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!--如果只是想要 Info 级别的日志，只是过滤 info 还是会输出 Error 日志，因为 Error 的级别高，
        所以我们使用下面的策略，可以避免输出 Error 的日志-->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!--过滤 Error-->
            <level>ERROR</level>
            <!--匹配到就禁止-->
            <onMatch>DENY</onMatch>
            <!--没有匹配到就允许-->
            <onMismatch>ACCEPT</onMismatch>
        </filter>
        <!--日志名称，如果没有File 属性，那么只会使用FileNamePattern的文件路径规则
            如果同时有<File>和<FileNamePattern>，那么当天日志是<File>，明天会自动把今天
            的日志改名为今天的日期。即，<File> 的日志都是当天的。
        -->
        <File>${logback.logdir}/info.${logback.appname}.log</File>
        <!--滚动策略，按照时间滚动 TimeBasedRollingPolicy-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--文件路径,定义了日志的切分方式——把每一天的日志归档到一个文件中,以防止日志填满整个磁盘空间-->
            <FileNamePattern>${logback.logdir}/info.${logback.appname}.%d{yyyy-MM-dd}.log</FileNamePattern>
            <!--只保留最近90天的日志-->
            <maxHistory>90</maxHistory>
            <!--用来指定日志文件的上限大小，那么到了这个值，就会删除旧的日志-->
            <!--<totalSizeCap>1GB</totalSizeCap>-->
        </rollingPolicy>
        <!--日志输出编码格式化-->
        <encoder>
            <charset>UTF-8</charset>
            <pattern>%d [%thread] %-5level %logger{36} %line - %msg%n</pattern>
        </encoder>
    </appender>


    <appender name="fileErrorLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!--如果只是想要 Error 级别的日志，那么需要过滤一下，默认是 info 级别的，ThresholdFilter-->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>Error</level>
        </filter>
        <!--日志名称，如果没有File 属性，那么只会使用FileNamePattern的文件路径规则
            如果同时有<File>和<FileNamePattern>，那么当天日志是<File>，明天会自动把今天
            的日志改名为今天的日期。即，<File> 的日志都是当天的。
        -->
        <File>${logback.logdir}/error.${logback.appname}.log</File>
        <!--滚动策略，按照时间滚动 TimeBasedRollingPolicy-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--文件路径,定义了日志的切分方式——把每一天的日志归档到一个文件中,以防止日志填满整个磁盘空间-->
            <FileNamePattern>${logback.logdir}/error.${logback.appname}.%d{yyyy-MM-dd}.log</FileNamePattern>
            <!--只保留最近90天的日志-->
            <maxHistory>90</maxHistory>
            <!--用来指定日志文件的上限大小，那么到了这个值，就会删除旧的日志-->
            <!--<totalSizeCap>1GB</totalSizeCap>-->
        </rollingPolicy>
        <!--日志输出编码格式化-->
        <encoder>
            <charset>UTF-8</charset>
            <pattern>%d [%thread] %-5level %logger{36} %line - %msg%n</pattern>
        </encoder>
    </appender>

    <appender name="controllerLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>INFO</level>
        </filter>
        <File>${logback.logdir}/controllerLog.log</File>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <FileNamePattern>${logback.logdir}/controllerLog-%d{yyyy-MM-dd}.%i.log</FileNamePattern>
            <!--只保留最近90天的日志-->
            <maxHistory>90</maxHistory>
            <!--用来指定日志文件的上限大小，那么到了这个值，就会删除旧的日志-->
            <!--日志文件保留天数-->
            <maxFileSize>1MB</maxFileSize>
            <totalSizeCap>10MB</totalSizeCap>
        </rollingPolicy>
        <encoder>
            <charset>UTF-8</charset>
            <pattern>%d [%thread] %-5level %logger{36} %line - %msg%n</pattern>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
        </encoder>
    </appender>

    <logger name="com.example.logtest.controller" level="INFO" additivity="true">
        <appender-ref ref="controllerLog"/>
    </logger>

    <root level="INFO">
        <appender-ref ref="consoleLog"/>
    </root>

</configuration>
```

```xml
<configuration>
    <property name="log.dir" value="/log/files"></property>
    <timestamp key="bySecond" datePattern="yyyyMMdd HHmmss"/>

    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <layout class="ch.qos.logback.classic.PatternLayout">
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} [%file:%line] - %msg%n</Pattern>
        </layout>
    </appender>

    <!-- 按日期和大小区分的滚动日志 -->
    <appender name="FILE_INFO" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>INFO</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.dir}/${APP_Name}/info/info.%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <maxHistory>30</maxHistory>

            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>10MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
    </appender>


    <!-- 按日期和大小区分的滚动日志 -->
    <appender name="FILE_DEBUG" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 必须指定，否则不会往文件输出内容 -->
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>DEBUG</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>

        <!-- 必需要指定rollingPolicy 与 triggeringPolicy 属性   否则不会生成文件-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.dir}/${APP_Name}/debug/debug.%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <maxHistory>30</maxHistory>

            <timeBasedFileNamingAndTriggeringPolicy
                    class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>10MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>

        </rollingPolicy>
    </appender>


    <!-- error级别只按日期滚动生成日志 -->
    <appender name="FILE_ERROR" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 必须指定，否则不会往文件输出内容 -->
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>ERROR</level>
            <!-- <onMatch>ACCEPT</onMatch>
                <onMismatch>DENY</onMismatch>-->
        </filter>

        <!-- 必需要指定rollingPolicy 与 triggeringPolicy 属性   否则不会生成文件-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.dir}/${APP_Name}/error/error.%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <maxHistory>30</maxHistory>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>10MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <!-- 默认值是10MB。 -->
        <!--     <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
                  <maxFileSize>5MB</maxFileSize>
            </triggeringPolicy>  -->
    </appender>

    <!-- 滚动记录文件 -->
    <appender name="MONITOR" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{85} - %msg%n</Pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>DEBUG</level>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.dir}/${APP_Name}/monitor/monitor.%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <maxHistory>30</maxHistory>
            <timeBasedFileNamingAndTriggeringPolicy
                    class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>10MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
    </appender>

    <logger name="org" level="INFO" />  <!--将org包下面的所有日志级别设为了ERROR -->
    <logger name="monitor" additivity="false" level="DEBUG" />

    <logger name="monitor" additivity="false" level="DEBUG">
        <appender-ref ref="MONITOR" />
    </logger>

    <root level="DEBUG">
        <appender-ref ref="STDOUT" />
        <appender-ref ref="FILE_INFO" />
        <appender-ref ref="FILE_DEBUG" /> //上线时 这个需注释掉，debug级别的日志
        <appender-ref ref="FILE_ERROR" />
    </root>
</configuration>
```