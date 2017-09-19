<template>
  <div>
    <text style="font-size: 60px;" @click="add">weex 渲染一只恐龙</text>
    <ar ref="scene" style="height: 1100;width: 750" @tap="tap">
      <model ref="shark" style="x:-4;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/shark.dae"> </model>
      <model ref="guard" style="x:-2;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model ref="dargon" style="x:0;y:-4;z:-5; scale:0.01"  src="https://gw.alicdn.com/bao/uploaded/LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip?spm=a1z3i.a4.0.0.26ca68fdHcV3s4&file=LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip" path="art.scnassets/dargon.dae"> </model>
      <model ref="shark" style="x:2;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/shark.dae"> </model>
      <model ref="guard" style="x:4;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model ref="dargon" style="x:6;y:-4;z:-5; scale:0.01"  src="https://gw.alicdn.com/bao/uploaded/LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip?spm=a1z3i.a4.0.0.26ca68fdHcV3s4&file=LB1yLD9d3oQMeJjy0FnXXb8gFXa.zip" path="art.scnassets/dargon.dae"> </model>
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