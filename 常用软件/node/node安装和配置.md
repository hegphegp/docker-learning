# Linux下，node的安装和配置

### 方法一:二进制在线下载安装,可以多用户使用(不行的话，再用方法二下载)
```
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 下面这句一定要运行，否则会认为国内node加速下载地址是不可信，导致不在国内加速器下载最新版本
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

# 安装 8.X版本
echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_8.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_8.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
cat /etc/apt/sources.list.d/nodesource.list 
apt-get update
apt-get install nodejs


# 安装 10.X版本
echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
cat /etc/apt/sources.list.d/nodesource.list 
apt-get update
apt-get install nodejs
```

### 方法二：压缩包下载安装，只能当前用户使用
```
# https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/ 查看nodejs的安装包
mkdir -p /opt/soft/nodejs
curl -L http://cdn.npm.taobao.org/dist/node/v8.15.1/node-v8.15.1-linux-x64.tar.gz > /opt/soft/nodejs/node-v8.15.1-linux-x64.tar.gz
tar -zxvf /opt/soft/nodejs/node-v8.15.1-linux-x64.tar.gz -C /opt/soft/nodejs
echo "export NODE_HOME=/opt/soft/nodejs/node-v8.15.1-linux-x64" >> /etc/profile
echo 'export PATH=$NODE_HOME/bin:$PATH' >> /etc/profile
source /etc/profile
node -v
npm -v

# /opt/soft/nodejs/node-v8.15.1-linux-x64/bin/node -v
# cd /opt/soft/nodejs/node-v8.15.1-linux-x64/bin && ./node -v
```

### 配置淘宝源
```
npm config set registry https://registry.npm.taobao.org --verbose
```

### 安装cnpm(用cnpm替代npm)
##### cnpm时阿里定制的命令行工具，用来代替默认的 npm
```
npm install -g cnpm --registry=https://registry.npm.taobao.org --verbose
cnpm -v
```

### 安装yarn(用yarn替代npm)
```
cnpm install -g yarn
# 或者 npm install -g yarn --verbose
```

```
$ \max_n f(n) = \sum_{i=1}^n A_i $：
```