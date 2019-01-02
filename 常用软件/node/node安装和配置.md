# Linux下，node的安装和配置

### node安装和配置
```
mkdir -p /opt/soft/nodejs
curl -L http://cdn.npm.taobao.org/dist/node/v8.14.1/node-v8.14.1-linux-x64.tar.gz > /opt/soft/nodejs/node-v8.14.1-linux-x64.tar.gz
tar -zxvf /opt/soft/nodejs/node-v8.14.1-linux-x64.tar.gz -C /opt/soft/nodejs
echo "export NODE_HOME=/opt/soft/nodejs/node-v8.14.1-linux-x64" >> /etc/profile
echo 'exportPATH=${NODE_HOME}/bin:$PATH' >> /etc/profile
source /etc/profile
node -v
npm -v

# /opt/soft/nodejs/node-v8.14.1-linux-x64/bin/node -v
# cd /opt/soft/nodejs/node-v8.14.1-linux-x64/bin && ./node -v
```

### 配置淘宝源
```
npm config set registry https://registry.npm.taobao.org -verbose
```

### 安装cnpm(用cnpm替代npm)
##### cnpm时阿里定制的命令行工具，用来代替默认的 npm
```
npm install -g cnpm --registry=https://registry.npm.taobao.org -verbose
cnpm -v
```

### 安装yarn(用yarn替代npm)
```
cnpm install -g yarn
# 或者 npm install -g yarn -verbose
```

```
$ \max_n f(n) = \sum_{i=1}^n A_i $：
```