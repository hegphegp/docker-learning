# Java常用命令

#### 后台运行Java服务的脚本命令
```
nohup java -Xmx64m -Xms64m -Xmn32m -Xss256k -jar -XX:ParallelGCThreads=2 -Djava.compiler=NONE springboot-web-memory-test-0.0.1-SNAPSHOT.jar > log.file  2>&1 &
nohup java -Xmx64m -Xms64m -Xmn32m -Xss256k -jar -XX:ParallelGCThreads=2 springboot-web-memory-test-0.0.1-SNAPSHOT.jar > log.file  2>&1 &
```
```
#!/bin/bash

# vi run.sh
java -Xmx2560m -Xms256m -Xmn128m -Xss1m -jar ureport2-springboot-1.0.0.jar --server.port=9898 >> log.log &

# http://localhost:9898/ureport/designer
# chmod a+x run.sh
```

#### java内存压榨
```
java -Xmx64m -Xms64m -Xmn32m -Xss1m -jar springboot-web-memory-test-0.0.1-SNAPSHOT.jar
# JVM默认线程栈大小是1M，一个线程默认分配的内存是1M
java -Xmx64m -Xms64m -Xmn32m -Xss256k -jar -XX:ParallelGCThreads=2 springboot-web-memory-test-0.0.1-SNAPSHOT.jar
# C2CompilerThread：JIT编译线程，动态编译Java运行代码，JIT是JVM为了优化执行频率比较高的字节码设计的技术，JIT把字节码编译为机器码，之后执行则不需要解释字节码，直接运行机器码即可。我们的服务没有什么负载，即使不优化也不受影响，这里的优化是把JIT关掉，在Java启动的参数中添加 => -Djava.compiler=NONE，这样就不会再有CompilerThread了
java -Xmx64m -Xms64m -Xmn32m -Xss256k -jar -XX:ParallelGCThreads=2 -Djava.compiler=NONE springboot-web-memory-test-0.0.1-SNAPSHOT.jar
```

#### gradle打包要添加的groovy脚本
```groovy
buildscript {
    ext {
        springBootVersion = '1.5.13.RELEASE'
    }
    repositories {
        mavenLocal()
        maven{ url "http://maven.aliyun.com/nexus/content/groups/public/"}
        mavenCentral()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
    }
}
apply plugin: 'org.springframework.boot'
```

### maven仓库的网页查看地址[http://maven.aliyun.com/mvn/view]()
仓库|仓库类型|仓库存储策略|阿里云的映射地址|
:---:|:---:|:---:|:---:
Repository | Type | Policy | Path
apache snapshots | proxy | SNAPSHOT | https://maven.aliyun.com/repository/apache-snapshots
central | proxy | RELEASE | https://maven.aliyun.com/repository/central
google  |proxy | RELEASE | https://maven.aliyun.com/repository/google
gradle-plugin | proxy | RELEASE	| https://maven.aliyun.com/repository/gradle-plugin
jcenter	| proxy	| RELEASE | https://maven.aliyun.com/repository/jcenter
spring | proxy | RELEASE | https://maven.aliyun.com/repository/spring
spring-plugin | proxy | RELEASE	| https://maven.aliyun.com/repository/spring-plugin
public | group | RELEASE | https://maven.aliyun.com/repository/public
releases | hosted | RELEASE | https://maven.aliyun.com/repository/releases
snapshots | hosted | SNAPSHOT | https://maven.aliyun.com/repository/snapshots
grails-core | proxy | RELEASE |https://maven.aliyun.com/repository/grails-core


#### maven的settings.xml配置文件
```
  <mirrors>
    <mirror>
      <id>aliyun-apache</id>
      <mirrorOf>aliyun-apache</mirrorOf>
      <name>aliyun-apache</name>
      <url>https://maven.aliyun.com/repository/apache-snapshots</url>
    </mirror>
    <mirror>
      <id>aliyun-central</id>
      <mirrorOf>aliyun-central</mirrorOf>
      <name>aliyun-central</name>
      <url>https://maven.aliyun.com/repository/central</url>
    </mirror>
    <mirror>
      <id>aliyun-google</id>
      <mirrorOf>aliyun-google</mirrorOf>
      <name>aliyun-google</name>
      <url>https://maven.aliyun.com/repository/google</url>
    </mirror>
    <mirror>
      <id>aliyun-gradle-plugin</id>
      <mirrorOf>aliyun-gradle-plugin</mirrorOf>
      <name>aliyun-gradle-plugin</name>
      <url>https://maven.aliyun.com/repository/gradle-plugin</url>
    </mirror>
    <mirror>
      <id>aliyun-gradle-plugin</id>
      <mirrorOf>aliyun-gradle-plugin</mirrorOf>
      <name>aliyun-gradle-plugin</name>
      <url>https://maven.aliyun.com/repository/gradle-plugin</url>
    </mirror>
    <mirror>
      <id>aliyun-jcenter</id>
      <mirrorOf>aliyun-jcenter</mirrorOf>
      <name>aliyun-jcenter</name>
      <url>https://maven.aliyun.com/repository/jcenter</url>
    </mirror>
    <mirror>
      <id>aliyun-spring</id>
      <mirrorOf>aliyun-spring</mirrorOf>
      <name>aliyun-spring</name>
      <url>https://maven.aliyun.com/repository/spring</url>
    </mirror>
    <mirror>
      <id>aliyun-spring-plugin</id>
      <mirrorOf>aliyun-spring-plugin</mirrorOf>
      <name>aliyun-spring-plugin</name>
      <url>https://maven.aliyun.com/repository/spring-plugin</url>
    </mirror>
    <mirror>
      <id>aliyun-public</id>
      <mirrorOf>aliyun-public</mirrorOf>
      <name>aliyun-public</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
    <mirror>
      <id>aliyun-releases</id>
      <mirrorOf>aliyun-releases</mirrorOf>
      <name>aliyun-releases</name>
      <url>https://maven.aliyun.com/repository/releases</url>
    </mirror>
    <mirror>
      <id>aliyun-snapshots</id>
      <mirrorOf>aliyun-snapshots</mirrorOf>
      <name>aliyun-snapshots</name>
      <url>https://maven.aliyun.com/repository/snapshots</url>
    </mirror>
    <mirror>
      <id>aliyun-grails-core</id>
      <mirrorOf>aliyun-grails-core</mirrorOf>
      <name>aliyun-grails-core</name>
      <url>https://maven.aliyun.com/repository/grails-core</url>
    </mirror>
  </mirrors>
```


#### build.gradle配置文件
```
repositories {
	mavenLocal()
	maven{ url "https://maven.aliyun.com/repository/apache-snapshots"}
    maven{ url "https://maven.aliyun.com/repository/central"}
    maven{ url "https://maven.aliyun.com/repository/google"}
    maven{ url "https://maven.aliyun.com/repository/gradle-plugin"}
    maven{ url "https://maven.aliyun.com/repository/jcenter"}
    maven{ url "https://maven.aliyun.com/repository/spring"}
    maven{ url "https://maven.aliyun.com/repository/spring-plugin"}
    maven{ url "https://maven.aliyun.com/repository/public"}
    maven{ url "https://maven.aliyun.com/repository/releases"}
    maven{ url "https://maven.aliyun.com/repository/snapshots"}
    maven{ url "https://maven.aliyun.com/repository/grails-core"}
	mavenCentral()
}
```