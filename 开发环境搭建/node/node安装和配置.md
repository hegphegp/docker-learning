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

### 安装vue脚手架
```
# 安装vue脚手架
npm install -g @vue/cli-init --verbose
# 用脚手架创建一个项目
vue init webpack vue-demo
```
### 关于 eslint
##### npm 全局安装 eslint 插件
```
npm install eslint -g --verbose
```

##### VSCode安装 eslint 插件
* 文件 > 首选项 > 设置 > 拓展 > ESLint > 在 settings.json中编辑 添加以下内容
```
"editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
},
"eslint.codeAction.showDocumentation": {
    "enable": true
}
```

##### 比较vue init创建新项目时，使用useEslint和不使用useEslint的差异
* 使用useEslint的项目，多出了 .eslintrc.js 和 .eslintignore 文件，package.json多出了 esLint 的依赖，config/index.js文件多出了 esLint 两行配置，build/webpack.base.conf.js文件多出了几行配置


### 全局安装 npm-check-updates 插件，该插件可以查看 package.json 中所有依赖的最新版本，可以让 package.json 的依赖包升级到最新版本
```
# 安装插件
npm install -g npm-check-updates --verbose
# 查看 package.json 中依赖包的最新版本
ncu
# 更新 package.json 中依赖包到最新版本
ncu -u
# 更新 package.json 全部依赖包到最新版本(包括当前指定版本范围满足最新版本号的,比如^4.2.0 -> ^4.3.0)
ncu -a

```

### npm指令在 package.json 中dependencies和devDependencies添加依赖
```
npm install <packagename> --save        # 在 package.json 的 dependencies 添加依赖
npm install <packagename> --save-dev    # 在 package.json 的 devDependencies 添加依赖
```

```
npm install ant-design-vue --save --verbose

import 'ant-design-vue/dist/antd.css'
import antDesignVue from 'ant-design-vue'

Vue.use(antDesignVue)

npm install vue-i18n --save --verbose
# Vuex 的内脏由五部分组成：State、Getter、Mutation、Action 和 Module。但是一般再怎么简单的 Vuex，也至少会由 State 和 Mutation 构成，否则你就该考虑 Vuex 是否有存在的必要了。
npm install vuex --save --verbose

mkdir -p src/module
touch src/module/app.js

```

### ES6语法中三个点表示扩展运算符，即…。它好比 rest 参数的逆运算，将一个数组转为用逗号分隔的参数序列

### computed中的属性和data中的属性名字不能相同，一个属性要么在data里，要么在computed里

### this.$store.getters 不能给 data属性字段直接赋值，要放到 computed 赋值
```
# mapGetters 辅助函数

<template>
  <div><div>{{from}}</div><div>{{from2}}</div></div>
</template>
 
<script>
import { mapGetters } from 'vuex'
export default {
  computed: mapGetters({
    'from': 'address', // computed 的属性都是方法，computed的方法名不能与data的属性同名
    'from2': 'addressMore',
    'find': 'findArr'
  }),
  created () {
    console.log(this.find(1)) // 由于getters已经通过computed挂载到当前实例,所以你不需要再通过this.$store.getters的方法去访问
  }
}
</script>

或者
<template>
  <div><div>{{from}}</div><div>{{from2}}</div></div>
</template>
 
<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters({
      'from': 'address',
      'from2': 'addressMore',
      'find': 'findArr'
    })
  },
  created () {
    console.log(this.find(1)) // 由于getters已经通过computed挂载到当前实例,所以你不需要再通过this.$store.getters的方法去访问
  }
}
</script>

或者
computed: {
    ...mapGetters([ // 这里是给 data 的属性赋值吗？还是表示什么
        'username'  // 这个值是store里面存的值
    ])
},

或者
<template>
  <div id="example">
    <button @click="decrement">-</button>
    {{count}}
    {{dataCount}}
    <button @click="increment">+</button>
  </div>
</template>
<script>
export default {
  data () {
    return {
      dataCount: this.$store.state.count // 用data接收，反面教材：data接收的值不能及时响应更新
    }
  },
  computed: {
    count() {
      return this.$store.state.count    // 用computed接收
    }
  },
  methods: {
    increment () {
      this.$store.commit('increment')
    },
    decrement () {
      this.$store.commit('decrement')
    }
  }
}
</script>

或者
computed:{
  sex:function() {
      return this.$store.state.sex + '加个字符串,算是改造'    
  }
}

或者
import { mapState } from 'vuex'

const deviceMixin = {
  computed: {
    ...mapState({
      isMobile: state => state.app.isMobile
    })
  }
}

export { deviceMixin }

```

### 死语法，这是要默写的内容，所有的写法都要受这种写法的约束，不能添加任何的灵活，否则程序运行就抛错，搞死你
```
<template>
  <div id="example"></div>
</template>
<script>
export default {
  name: "TestComponent",  // 官方推荐: 给组件起个名字, 便于报错时的提示
  data () { // data后面有个括号，死记硬背，别搞小聪明，别找人辩论这有多么反人类，不写，运行直接抛错，搞死你
    return {
      dataCount: this.$store.state.count // 用data接收，反面教材：data接收的值不能及时响应更新
    }
  },
  computed: { // computed 是个属性，属性里面可以有方法
    count() { // count后面有个括号，死记硬背，别搞小聪明，别找人辩论这有多么反人类，不写，运行直接抛错，搞死你
      return this.$store.state.count    // 用computed接收
    }
  },
  methods: {
    increment () {
      this.$store.commit('increment')
    },
    decrement () {
      this.$store.commit('decrement')
    }
  }
}
</script>
```

### vuex的store的写法模板
```
import storage from 'store'
import { login, getInfo, logout } from '@/api/login'

const user = {
  state: {
    token: '',
    name: '',
    avatar: '',
    roles: []
  },

  mutations: {
    SET_TOKEN: (state, token) => { // 传参写法，是不是 mutations 方法的第一个参数是默认的，不用调用方传，第一个参数只能是state
      state.token = token
    },
    SET_NAME: (state, { name, avatar }) => { // 传参写法，是不是 mutations 方法的第一个参数是默认的，不用调用方传，第一个参数只能是state
      state.name = name
      state.avatar = avatar
    },
    SET_ROLES: (state, roles) => { // 传参写法，是不是 mutations 方法的第一个参数是默认的，不用调用方传，第一个参数只能是state
      state.roles = roles
    }
  },

  actions: {
    Login ({ commit }, userInfo) { // 传参写法，是不是 actions 方法的第一个参数是默认的，不用调用方传，第一个参数可以包含 commit，state
      return new Promise((resolve, reject) => { // new Promise的参数写法，是不是actions的每个方法都要返回 new Promise
        login(userInfo).then(response => {
          storage.set('ACCESS_TOKEN', response.result.token, 7 * 24 * 60 * 60 * 1000)
          commit('SET_TOKEN', response.result.token)
          resolve() // 无论是否有参数返回，都要写 resolve() 吗，即使 resolve() 是空方法
        }).catch(error => {
          reject(error) // 抛出异常的写法
        })
      })
    },

    GetInfo ({ commit }) { // 传参写法，是不是 actions 方法的第一个参数是默认的，不用调用方传，第一个参数可以包含 commit，state
      return new Promise((resolve, reject) => { // new Promise的参数写法，是不是actions的每个方法都要返回 new Promise
        getInfo().then(response => {
          const result = response.result
          if (result.role && result.role.permissions.length > 0) {
            const role = result.role
            commit('SET_ROLES', result.role)
          } else {
            reject(new Error('getInfo: roles must be a non-null array !')) // 抛出异常的写法
          }
          commit('SET_NAME', { name: result.name, avatar: result.avatar }) // commit 方法多个参数
          resolve(response)
        }).catch(error => {
          reject(error) // 抛出异常的写法
        })
      })
    },

    Logout ({ commit, state }) { // 传参写法，是不是 actions 方法的第一个参数是默认的，不用调用方传，第一个参数可以包含 commit，state
      return new Promise((resolve) => { // new Promise的参数写法，是不是actions的每个方法都要返回 new Promise
        logout(state.token).then(() => {
          resolve() // 无论是否有参数返回，都要写 resolve() 吗，即使 resolve() 是空方法
        }).catch(() => {
          resolve() // 无论是否有参数返回，都要写 resolve() 吗，即使 resolve() 是空方法
        }).finally(() => {
          commit('SET_TOKEN', '')
          commit('SET_ROLES', [])
          storage.remove('ACCESS_TOKEN')
        })
      })
    }
  }
}

export default user
```
### 一个js文件多次export的写法
```
export const asyncRouterMap = {}
export const constantRouterMap = {}
```

### vuex中 this.$store.dispatch() 与 this.$store.commit()方法的区别
* this.$store.dispatch() 与 this.$store.commit()方法的区别是两者的传参方法是否包含异步或者同步操作
* this.$store.dispatch() : 传参方法含有异步操作，写法：this.$store.dispatch('action方法名', 值)，action方法名的方法体再通过 commit 方法调用 mutations的方法
* this.$store.commit() : 传参方法是同步操作，写法：this.$store.commit('mutations方法名', 值)

##### commit: 传参方法是有同步操作
```
存储 this.$store.commit('changeValue', name)
取值 this.$store.state.changeValue
```

##### dispatch: 传参方法含有异步操作
```
存储 this.$store.dispatch('getlists', name)
取值 this.$store.getters.getlists
```

### vuex的 this.$store 在 ant-design-vue-pro项目中不能直接用，必须手动引入 '@/store' 的地方有，其他地方不用手动引入，直接用 this.$store 
* src/utils/request.js
* src/router/navigationRouter.js
* src/core/initValue.js

### jsconfig.json 可有可无
* jsconfig.json 文件来定义项目上下文时，表明该目录是 JavaScript 项目的根目录，可以配置属于项目的文件、要从项目中排除的文件以及编译器选项。如果不使用JavaScript，就不需要配置jsconfig.json。tsconfig.json 配置高于 jsconfig.json，它是TypeScript的配置文件。配置了tsconfig.json的情况下 allowJs:true jsconfig.json 才生效。

### vue的import引入，路径的三种格式
* 一种路径前面带@，表示引入当前项目src中的文件
* 一种路径前面不带@，表示引入某个模块的文件，这个文件不在项目的src目录
* 一种路径前面不带@，但是带 ./ 或者 ../，表示当前项目的相对文件

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