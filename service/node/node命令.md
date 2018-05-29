# node命令

### npm命令的正确使用方法,必须加 - verbose 参数, 显示进度, 例如
```
npm install -g cnpm --registry=https://registry.npm.taobao.org
npm install -verbose
npm run build -verbose
```

### 默认情况下npm install安装所有依赖项，包括devDependencies部分。有了--production标签，就可以从package.json文件中安装所需的依赖,体积减少两三百兆
```
npm install -g cnpm --registry=https://registry.npm.taobao.org
npm install --production -verbose 
```