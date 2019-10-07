# node命令


### npm命令的正确使用方法,必须加 - verbose 参数, 显示进度, 例如
```
docker run -itd --restart always --name sshop-web -p 8888:80 -v /home/hgp/shop-admin-web:/node node:8.11.4-alpine sh
npm config set registry https://registry.npm.taobao.org
npm install -verbose
npm run build -verbose
```

### 默认情况下npm install安装所有依赖项，包括devDependencies部分。有了--production标签，就可以从package.json文件中安装所需的依赖,体积减少两三百兆
```
npm config set registry https://registry.npm.taobao.org -verbose
npm install --production -verbose 


npm config set registry https://registry.npm.taobao.org -verbose
npm run dev -verbose
```

## Yarn是一个新的快速安全可信赖的可以替代NPM的依赖管理工具
```
# 快速安装, 在NPM中安装
npm install -g yarn

# 1.查询NPM当前配置的镜像
npm get registry
# 输出结果 https://registry.npmjs.org/
# npm config get registry
# npm config --help
# npm config list --json
# 设置成淘宝镜像
npm config set registry https://registry.npm.taobao.org
npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/
npm config set electron_mirror https://npm.taobao.org/mirrors/electron/
npm config set sqlite3_binary_host_mirror https://npm.taobao.org/mirrors/sqlite3/
npm config set profiler_binary_host_mirror https://npm.taobao.org/mirrors/node-inspector/
npm config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver/
npm config set puppeteer_download_host=https://npm.taobao.org/mirrors/


# 1.查询Yarn当前配置的镜像
yarn config get registry
# 输出结果 https://registry.yarnpkg.com
# yarn config --help
# yarn config list
# 设置成淘宝镜像
yarn config set registry https://registry.npm.taobao.org/
yarn config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
yarn config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/
yarn config set electron_mirror https://npm.taobao.org/mirrors/electron/
yarn config set sqlite3_binary_host_mirror https://npm.taobao.org/mirrors/sqlite3/
yarn config set profiler_binary_host_mirror https://npm.taobao.org/mirrors/node-inspector/
yarn config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver/
yarn config set puppeteer_download_host=https://npm.taobao.org/mirrors/

```