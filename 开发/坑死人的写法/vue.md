#### 引入路由时, 有人写 Vue.use(Router) 这一行代码, 发现去掉这一行代码, 项目可以跑起来, 百思不得其解, 也没任何人解释过, 本身写前端, 各种配置就搞得人无从下手, 还加各种坑死人的模棱两可的写法, 害别人
###### 主要的main.js
```
import 'core-js/stable'

import Vue from 'vue'
import Router from 'vue-router'
import { constantRouterMap } from '@/config/router.config'

// Vue.use(Router); // 有人写多了这一行, 愣是没想懂有什么用, 注释了这一行, 代码还是可以跑其他, 配置这一行有屁用吗, 配置把我整得昏头转向
const routerConfig = new Router({
  mode: 'history',
  routes: constantRouterMap // 部分路由, 不需要登录也可以访问的路由
})

new Vue({
  routerConfig,
  store,
  created: bootstrap,
  render: h => h(App)
}).$mount('#app')

```

// 动态配置路由, 即登录后, 返回了一部分路由, 动态加到vue路由里面去
```
import Vue from 'vue'
import Router from 'vue-router'
import { constantRouterMap } from '@/config/router.config'

const routerConfig = new Router({
  mode: 'history',
  routes: constantRouterMap // 部分路由, 不需要登录也可以访问的路由
})

new Vue({
  routerConfig, // 添加不需要登录就可以访问的路由
  store,
  created: bootstrap,
  render: h => h(App)
}).$mount('#app')


### 添加登陆后, 后台返回的路由, 在路由导航里面, 动态添加后端返回的路由
##### vueRouter.js 文件内容
import Vue from 'vue'
import Router from 'vue-router'
import { constantRouterMap } from '@/config/router.config'

export default new Router({
  mode: 'history',
  routes: constantRouterMap
})

##### 在导航路由里面, 动态添加路由
import router from './vueRouter'

router.addRoutes(store.getters.routers)

```