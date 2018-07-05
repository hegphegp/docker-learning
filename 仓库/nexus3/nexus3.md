# nexus3仓库的配置

```
# nexus3不需要离线下载索引，没有离线配置索引和没有在线更新索引的说法，nexus3的索引是由elasticsearch维护
su root
mkdir -p /opt/soft/nexus3
# 必须把挂载目录赋予200用户，如果赋予其他用户的话，启动两三分钟后容器日志显示没有权限，要么不挂载，要么挂载目录赋予200用户
chown -R 200 /opt/soft/nexus3
# 以下docker命令执行后要等5分钟再去访问 18081 端口才行
docker run -itd  --restart always -p 18081:8081 --name nexus -v /opt/soft/nexus3:/nexus-data sonatype/nexus3:3.12.1
```

##### gradle全局配置代理路径
```
mkdir -p ~/.gradle
tee ~/.gradle/init.gradle <<-'EOF'
// allprojects{
//     repositories {
//         def REPOSITORY_URL = 'http://localhost:18081/repository/maven-central/'
//         all { ArtifactRepository repo ->
//             if(repo instanceof MavenArtifactRepository){
//                 def url = repo.url.toString()
//                 if (url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('https://jcenter.bintray.com/') || url.startsWith('http://maven.aliyun.com/nexus/')) {
//                     project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
//                     remove repo
//                 }
//             }
//         }
//         maven {
//             url REPOSITORY_URL
//         }
//     }
// }

// buildscript {
//     repositories {
//         maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
//     }
// }

// allprojects {
//     repositories {
//         maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
//     }
// }

allprojects {
    repositories {
        maven{ url 'http://192.168.4.8:18081/repository/maven-central/'}
    }
}

EOF
```

##### maven全局配置代理路径
```
mkdir -p ~/.m2
tee ~/.m2/settings.xml <<-'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <!-- localRepository
  <localRepository>/path/to/local/repo</localRepository>
  -->

  <pluginGroups></pluginGroups>

  <proxies></proxies>

  <servers></servers>

  <mirrors>
    <mirror>
      <id>local_repo11</id>
      <!--<mirrorOf>*</mirrorOf>-->
      <!--<mirrorOf>aliyun,central</mirrorOf>-->
      <mirrorOf>aliyun</mirrorOf>
  　　  <url>http://192.168.4.8:18081/repository/maven-central/</url>
    </mirror>
  </mirrors>

  <profiles></profiles>
</settings>
EOF
```