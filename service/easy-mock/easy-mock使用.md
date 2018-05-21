## easy-mock使用.md

#### 制作镜像
###### docker build -t easy-mock:1.5.1 .
```
FROM ubuntu:16.04

RUN apt-get update ;\
    apt-get install --no-install-recommends -y wget jq ca-certificates; \
    wget http://cdn.npm.taobao.org/dist/node/v8.4.0/node-v8.4.0-linux-x64.tar.gz; \
    tar -xzvf node-v8.4.0-linux-x64.tar.gz; \
    ln -s /node-v8.4.0-linux-x64/bin/node /usr/local/bin/node; \
    ln -s /node-v8.4.0-linux-x64/bin/npm /usr/local/bin/npm; \
    rm -rf /node-v8.4.0-linux-x64.tar.gz

RUN mkdir /easy-mock ; \
    wget https://github.com/easy-mock/easy-mock/archive/v1.5.1.tar.gz ; \
    tar -xzvf v1.5.1.tar.gz -C /easy-mock --strip-components 1 ; \
    rm -rf v1.5.1.tar.gz ; \
    cd /easy-mock/config ; \
    npm config set registry https://registry.npm.taobao.org; \
    jq '.db = "mongodb://mongodb/easy-mock"' default.json > tmp.json && mv tmp.json default.json ; \
    jq '.redis = { port: 6379, host: "redis" }' default.json > tmp.json && mv tmp.json default.json ; \
    cp default.json production.json

RUN apt-get autoclean && apt-get clean && apt-get autoremove
WORKDIR /easy-mock
RUN npm install -verbose && npm run build
EXPOSE 7300

CMD [ "npm", "start", "-verbose" ]
```

#### 必须谨记,不是所有的node的docker镜像都可以打包这个应用的,曾经用了 node:10.1-alpine镜像,打包的时候,easy-mock程序老出错
#### 启动服务
##### docker run -itd --name easy-mock --link redis:redis --link mongo:mongodb easy-mock:1.5.1
##### 很无奈的现实,配置文件/easy-mock/config/production.json的redis配置为
#### production.json配置文件如下,所以必须覆盖为
```
{
  "port": 7300,
  "host": "0.0.0.0",
  "pageSize": 30,
  "proxy": false,
  "db": "mongodb://mongodb/easy-mock",
  "unsplashClientId": "",
  "redis": {
    "port": 6379,
    "host": "redis"
  },
  "blackList": {
    "projects": [],
    "ips": []
  },
  "rateLimit": {
    "max": 1000,
    "duration": 1000
  },
  "jwt": {
    "expire": "14 days",
    "secret": "shared-secret"
  },
  "upload": {
    "types": [".jpg", ".jpeg", ".png", ".gif", ".json", ".yml", ".yaml"],
    "size": 5242880,
    "dir": "../public/upload",
    "expire": {
      "types": [".json", ".yml", ".yaml"],
      "day": -1
    }
  },
  "fe": {
    "copyright": "",
    "storageNamespace": "easy-mock_",
    "timeout": 25000,
    "publicPath": "/dist/"
  }
}
```