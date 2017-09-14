<template>
  <div>
    <text style="font-size: 60px;" @click="add">weex 渲染一个矩形</text>
    <ar ref="scene" style="height: 1100;width: 750" @tap="tap">
      <box style="x:0.1;y:0.1;z:-0.5;width: 0.1;height: 0.1;length:0.1;chamfererRadius:0;color: red" texture="https://github.com/kfeagle/firstdemo/blob/master/taobao.jpg?raw=true"> </box>
      <sphere style="x:0;y:0.1;z:-0.5;radius:0.025;color: red" texture="https://github.com/kfeagle/firstdemo/blob/master/bullet.jpg?raw=true"> </sphere>
    </ar>
  </div>
</template>

<script>
  module.exports = {
    data: function () {
      return {
      };
    },
  }
</script>