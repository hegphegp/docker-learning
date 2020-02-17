### DvaJS教程
* [官方文档](https://dvajs.com/guide/)
* 官方提示dva-cli命令已经过时，建议用umi创建dva项目 dva-cli is deprecated, please use create-umi instead, checkout https://umijs.org/guide/create-umi-app.html for detail.

#### 官方建议的创建项目的方法
* 01) 使用umi创建项目
```
mkdir myapp && cd myapp
yarn global add umi  # 全局安装umi插件
yarn create umi
```

* 02) Choose projec
```
? Select the boilerplate type (Use arrow keys)
  ant-design-pro  - Create project with an layout-only ant-design-pro boilerplate, use together with umi block.
❯ app             - Create project with a simple boilerplate, support typescript.
  block           - Create a umi block.
  library         - Create a library with umi.
  plugin          - Create a umi plugin.
```

* 03) Confirm if you want to use TypeScript.
```
? Do you want to use typescript? (y/N)
```

* 04) Then, select the function you need, checkout plugin/umi-plugin-react for the detailed description.
```
? What functionality do you want to enable? (Press <space> to select, <a> to toggle all, <i> to invert selection)
  antd
❯ dva
  code splitting
  dll
```

* 05) Once determined, the directories and files will be automatically created based on your selection.
```
   create package.json
   create .gitignore
   create .editorconfig
   create .env
   create .eslintrc
   create .prettierignore
   create .prettierrc
   create .umirc.js
   create mock/.gitkeep
   create src/app.js
   create src/assets/yay.jpg
   create src/global.css
   create src/layouts/index.css
   create src/layouts/index.js
   create src/models/.gitkeep
   create src/pages/index.css
   create src/pages/index.js
   create webpack.config.js
✨  File Generate Done
✨  Done in 161.20s.
```

* 06) Then install the dependencies manually,
```
yarn
```

* 07) Finally, start local development server with yarn start.
```
yarn start
```

