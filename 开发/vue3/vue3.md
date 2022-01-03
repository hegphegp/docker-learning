# vue3

#### vue3—reactive如何更改属性

* 注意：使用let定义后不能直接重新赋值reactive对象，会导致响应式的代理被覆盖。

#### 下面的用法是错误的
```
export default {
  name: 'App',
  setup() {
    let obj = reactive({a:1})
    // 不能这么写，这样重新赋值后会，obj会变成普通对象,失去响应式的效果;
    setTimeout(() => {
      obj = {a:2,b:3}
    }, 1000)
    return {
      obj
    }
  }
}
```

#### 下面的用法是正确的

* 用const定义reactive对象，要改变值时，要一个个字段单独赋值，不能直接用新对象替换

```
const obj = reactive({a:1})
setTimeout(() => {
  obj.a = 2;
  obj.b = 3;
}, 1000)
```

#### 下面的用法是正确的

* 使用Object.assign方法操作对象

```
export default {
  name: 'App',
  setup() {
    const obj = reactive({a:1})
    setTimeout(() => {
      Object.assign(obj,{a:2, b:3})  // 使用Object.assign方法操作对象
    }, 1000)
    return {
      obj
    }
  }
}
```