#### maven的settings.xml配置文件, mirrorOf的名称都设为 central , 好像maven下载插件时，默认是通过central的mirror对应的URL去查找，找遍了自定义的central后，再去官方默认的central找
```
<mirrors>
    <mirror>
        <id>aliyun-central</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-central</name>
        <url>https://maven.aliyun.com/repository/central/</url>
    </mirror>
    <mirror>
        <id>nexus-aliyun</id>
        <mirrorOf>central</mirrorOf>
        <name>Nexus aliyun</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
    </mirror> 
    <mirror>
        <id>aliyun-apache</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-apache</name>
        <url>https://maven.aliyun.com/repository/apache-snapshots/</url>
    </mirror>
    <mirror>
        <id>aliyun-google</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-google</name>
        <url>https://maven.aliyun.com/repository/google/</url>
    </mirror>
    <mirror>
        <id>aliyun-gradle-plugin</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-gradle-plugin</name>
        <url>https://maven.aliyun.com/repository/gradle-plugin/</url>
    </mirror>
    <mirror>
        <id>aliyun-gradle-plugin</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-gradle-plugin</name>
        <url>https://maven.aliyun.com/repository/gradle-plugin/</url>
    </mirror>
    <mirror>
        <id>aliyun-jcenter</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-jcenter</name>
        <url>https://maven.aliyun.com/repository/jcenter/</url>
    </mirror>
    <mirror>
        <id>aliyun-spring</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-spring</name>
        <url>https://maven.aliyun.com/repository/spring/</url>
    </mirror>
    <mirror>
        <id>aliyun-spring-plugin</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-spring-plugin</name>
        <url>https://maven.aliyun.com/repository/spring-plugin/</url>
    </mirror>
    <mirror>
        <id>aliyun-public</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-public</name>
        <url>https://maven.aliyun.com/repository/public/</url>
    </mirror>
    <mirror>
        <id>aliyun-releases</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-releases</name>
        <url>https://maven.aliyun.com/repository/releases/</url>
    </mirror>
    <mirror>
        <id>aliyun-snapshots</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-snapshots</name>
        <url>https://maven.aliyun.com/repository/snapshots/</url>
    </mirror>
    <mirror>
        <id>aliyun-grails-core</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun-grails-core</name>
        <url>https://maven.aliyun.com/repository/grails-core/</url>
    </mirror>
  </mirrors>
```


#### build.gradle配置文件
```
repositories {
    mavenLocal()
    maven { url "http://maven.aliyun.com/nexus/content/groups/public/" }
    maven { url "https://maven.aliyun.com/repository/central/" }
    maven { url "https://maven.aliyun.com/repository/jcenter/" }
    maven { url "https://maven.aliyun.com/repository/apache-snapshots/" }
    maven { url "https://maven.aliyun.com/repository/google/" }
    maven { url "https://maven.aliyun.com/repository/gradle-plugin/" }
    maven { url "https://maven.aliyun.com/repository/spring/" }
    maven { url "https://maven.aliyun.com/repository/spring-plugin/" }
    maven { url "https://maven.aliyun.com/repository/public/" }
    maven { url "https://maven.aliyun.com/repository/releases/" }
    maven { url "https://maven.aliyun.com/repository/snapshots/" }
    maven { url "https://maven.aliyun.com/repository/grails-core/" }
    mavenCentral()
}
```