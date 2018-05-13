# jhipster命令

```
jhipster import-jdl jhipster-jdl.jh --force
```

```
# 如果运行 gradlew 命令, 必须确保gradle的安装解压文件存在,否则下载官网的安装包会炸掉
docker stop jhipster
docker rm jhipster
docker pull jhipster/jhipster:v4.14.1
rm -rf /opt/soft/jhipster/demo/app
mkdir -p /opt/soft/jhipster/demo/gradle
mkdir -p /opt/soft/jhipster/demo/app
chmod -R 777 /opt/soft/jhipster/demo/app
docker run -itd --name jhipster -v /opt/soft/jhipster/demo/gradle:/gradle -v /opt/soft/jhipster/demo/app:/home/jhipster/app -p 3001:8080 -p 3002:9000 -p 3003:3001 jhipster/jhipster:v4.14.1
docker exec -it jhipster sh
npm config set registry https://registry.npm.taobao.org
cd /home/jhipster/app
jhipster

current_project_path=$(pwd)
echo "distributionBase=GRADLE_USER_HOME" > $current_project_path/gradle/wrapper/gradle-wrapper.properties
echo "distributionPath=wrapper/dists" >> $current_project_path/gradle/wrapper/gradle-wrapper.properties
echo "zipStoreBase=GRADLE_USER_HOME" >> $current_project_path/gradle/wrapper/gradle-wrapper.properties
echo "zipStorePath=wrapper/dists" >> $current_project_path/gradle/wrapper/gradle-wrapper.properties
echo "distributionUrl=gradle-4.4-bin.zip" >> $current_project_path/gradle/wrapper/gradle-wrapper.properties
cp /gradle/gradle-4.4-bin.zip -f $current_project_path/gradle/wrapper/

sed -i 's:jcenter():maven { url "http\://maven.aliyun.com/nexus/content/groups/public/" }\n        maven { url "http\://maven.aliyun.com/nexus/content/repositories/gradle-plugin/" }\n        maven { url "http\://maven.aliyun.com/nexus/content/repositories/jcenter/" }\n        jcenter() { url "http\://maven.aliyun.com/nexus/content/repositories/gradle-plugin/" }\n        jcenter() { url "http\://maven.aliyun.com/nexus/content/repositories/jcenter/" }\n        jcenter():g' build.gradle ;

./gradlew
```