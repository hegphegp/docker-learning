# Ubuntu下node的安装和配置

#### 安装软件用sudo或者root安装, 配置npm的插件下载地址，用开发账号用户配置插件地址，用root开发就用root账号执行配置地址命令，用开发账号开发就用开发账号执行配置地址命令
```
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 下面这句一定要运行，否则会认为nodejs的仓库地址是不可信，导致不能下载安装nodejs软件
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

mkdir -p /etc/profile.d
echo "#set npm environment" > /etc/profile.d/npm-config.sh
echo 'export PATH=~/.npm-global/bin:$PATH' >> /etc/profile.d/npm-config.sh
chmod 755 /etc/profile.d/npm-config.sh

# 安装 10.X版本
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_10.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
# apt-get update
# apt-get install -y nodejs

# 安装 11.X版本
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_11.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_11.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
# apt-get update
# apt-get install -y nodejs

# 安装 12.X版本
echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_12.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_12.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs

# 安装 13.X版本
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_13.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list
# echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_13.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list
# apt-get update
# apt-get install -y nodejs

# 修改 npm 安装插件的目录是 当前用户的 ~/.npm-global目录, 切回普通用户执行下面命令
npm config set prefix '~/.npm-global'

npm config set registry https://registry.npm.taobao.org --verbose
npm install -g cnpm --registry=https://registry.npm.taobao.org --verbose
cnpm -v
npm install -g yarn --verbose
yarn -v
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

npm config get registry
npm config list --json


yarn config set registry https://registry.npm.taobao.org
yarn config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
yarn config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/
yarn config set electron_mirror https://npm.taobao.org/mirrors/electron/
yarn config set sqlite3_binary_host_mirror https://npm.taobao.org/mirrors/sqlite3/
yarn config set profiler_binary_host_mirror https://npm.taobao.org/mirrors/node-inspector/
yarn config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver/
yarn config set puppeteer_download_host=https://npm.taobao.org/mirrors/

yarn config get registry
yarn config list

```

### 全局删除所有npm模块
```
npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm
# 下面是它的工作原理：
# npm ls -gp --depth=0列出所有全局顶级模块（有关ls，请参阅cli文档）
# awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}'  #打印实际上不是npm本身的所有模块（不以结尾/npm）
# xargs npm -g rm 全局删除前一个管道上的所有模块
```

### npm-查看依赖库最新版本及历史版本指令记录
```
npm view <packagename> versions
npm view antd versions
npm view babel-plugin-import versions
```

```
后端接口返回的数据错误时，必须打印日志，没打印，就是严重失误
console打印错误日志的正确方式，必须全红，必须粗体，必须大字体， %c 开头表示配置样式
console.error('%c ' + errMsg, 'font-weight:bold;');
```