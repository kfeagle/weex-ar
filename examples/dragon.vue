<template>
  <div>
    <text style="font-size: 60px;" @click="add">weex 渲染一只恐龙</text>
    <ar ref="scene" style="height: 1100;width: 750" @tap="tap">
      <model ref="dargon" style="x:1;y:-4;z:-5; scale:0.01"  src="https://gw.alicdn.com/bao/uploaded/LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip?spm=a1z3i.a4.0.0.26ca68fdHcV3s4&file=LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip" path="art.scnassets/dargon.dae"> </model>
      <model ref="dargon2" style="x:0;y:1;z:5; scale:0.01"  src="https://gw.alicdn.com/bao/uploaded/LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip?spm=a1z3i.a4.0.0.26ca68fdHcV3s4&file=LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip" path="art.scnassets/dargon.dae"> </model>

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