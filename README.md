# weex-ar
weex-ar是一个weex插件，可以通过weexpack快速集成，可以丰富weex功能

支持的weexpack版本： >= 0.2.0
支持的WeexSDK版本： >= 0.10.0

# demo
```html
<template>
  <div>
    <text style="font-size: 60px;" @click="add">weex 渲染一个矩形</text>
    <scene ref="scene" style="height: 1100;width: 750" @tap="tap"></scene>
  </div>
</template>

<script>
  module.exports = {
    data: function () {
      return {
        index: 0
      };
    },
    mounted: function () {
      console.log('Data observation finished')
      this.$refs['scene'].addNode({
        name:'color',
        width:0.1,
        height:0.1,
        length:0.1,
        chamferRadius:0,
        vector:{
          x:0.1,
          y:0.1,
          z:-0.5
        },
        contents:{
          type:'color',
          name:'red'
        }
      });
    }
  }
</script>
```

# 功能

# 快速使用
- 通过weexpack初始化一个测试工程 weextest
   ```
   weexpack create weextest
   ```
- 添加ios平台
  ```
  weexpack platform add ios
  ```
- 添加android平台
  ```
  weexpack platform add android
  ```
- 添加插件
  ```
  weexpack plugin add weex-ar
  ```
# 项目地址
[github](please add you source code address)

# 已有工程集成
## iOS集成插件WeexAr
- 命令行集成
  ```
  weexpack plugin add weex-ar
  ```
- 手动集成
  在podfile 中添加
  ```
  pod 'WeexAr'
  ```

## 安卓集成插件weexar
- 命令行集成
  ```
  weexpack plugin add weex-ar
  ```
- 手动集成
  在相应工程的build.gradle文件的dependencies中添加
  ```
  compile '${groupId}:weexar:{$version}'
  ``` 
  注意：您需要自行指定插件的groupId和version并将构建产物发布到相应的依赖管理仓库内去（例如maven）, 您也可以对插件的name进行自定义，默认将使用插件工程的名称作为name


## 浏览器端集成 weex-ar
- 命令行集成
  ```
  npm install  weex-ar
  ```
- 手动集成
  在相应工程的package.json文件的dependencies中添加
  ```
  weex-ar:{$version}'
  ``` 
  
