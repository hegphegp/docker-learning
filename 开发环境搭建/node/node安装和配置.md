# Linux下，node的安装和配置

* npm, cnpm, yarn 去掉加速器配置
```
npm config delete registry
cnpm config delete registry
yarn config delete registry
```

### 直接copy运行，不要浪费时间
```
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 下面这句一定要运行，否则会认为国内node加速下载地址是不可信，导致不在国内加速器下载最新版本
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

# 安装 10.X版本
echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs

# 安装 11.X版本
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_11.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_11.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
# apt-get update
# apt-get install -y nodejs

# 安装 12.X版本
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_12.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_12.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
# apt-get update
# apt-get install -y nodejs

# 安装 13.X版本
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_13.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_13.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
# apt-get update
# apt-get install -y nodejs


npm config set registry https://registry.npm.taobao.org --verbose
npm install -g cnpm --registry=https://registry.npm.taobao.org --verbose
npm install -g yarn --verbose
yarn config set registry https://registry.npm.taobao.org/

# 部分软件单独设置加速地址
npm config set registry https://registry.npm.taobao.org
npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/
npm config set electron_mirror https://npm.taobao.org/mirrors/electron/
npm config set sqlite3_binary_host_mirror https://npm.taobao.org/mirrors/sqlite3/
npm config set profiler_binary_host_mirror https://npm.taobao.org/mirrors/node-inspector/
npm config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver/
npm config set puppeteer_download_host=https://npm.taobao.org/mirrors/
```

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
apt-get install -y nodejs


# 安装 10.X版本
echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
cat /etc/apt/sources.list.d/nodesource.list 
apt-get update
apt-get install -y nodejs
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

### 修改 npm 安装插件的目录是 当前用户的 ~/.npm-global目录，用root用户执行下面的命令
```
npm config set prefix '~/.npm-global'
mkdir -p /etc/profile.d
echo "#set npm environment" > /etc/profile.d/npm-config.sh
echo 'export PATH=~/.npm-global/bin:$PATH' >> /etc/profile.d/npm-config.sh
chmod 755 /etc/profile.d/npm-config.sh
source /etc/profile
```

### 全局删除所有npm模块
```
npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm
# 下面是它的工作原理：
# npm ls -gp --depth=0列出所有全局顶级模块（有关ls，请参阅cli文档）
# awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}'  #打印实际上不是npm本身的所有模块（不以结尾/npm）
# xargs npm -g rm 全局删除前一个管道上的所有模块
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
# 修改yarn源为淘宝源
yarn config set registry https://registry.npm.taobao.org/
# 修改yarn源为官方源
# yarn config set registry https://registry.yarnpkg.com
```

```
$ \max_n f(n) = \sum_{i=1}^n A_i $：
```