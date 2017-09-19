<template>
  <div>
    <text style="font-size: 60px;" @click="add">weex 渲染12个突击兵</text>
    <ar ref="scene" style="height: 1100;width: 750" @tap="tap" @click="update">
      <model  style="x:-2;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae" :style="{ color: boxcolor }"> </model>
      <model style="x:0;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model  style="x:2;y:-4;z:-5; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model  style="x:-2;y:-4;z:-9; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model style="x:0;y:-4;z:-9; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model  style="x:2;y:-4;z:-9; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model  style="x:-2;y:-4;z:-11; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model style="x:0;y:-4;z:-11; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>
      <model  style="x:2;y:-4;z:-11; scale:1"  src="https://gw.alicdn.com/bao/uploaded/LB1hIbke3oQMeJjy1XaXXcSsFXa.zip?spm=a1z3i.a4.0.0.26ca68fdplMuuU&file=LB1hIbke3oQMeJjy1XaXXcSsFXa.zip" path="art.scnassets/guard.dae"> </model>

    </ar>
  </div>
</template>

<script>
  var modal = weex.requireModule('modal')
  module.exports = {
    data: {
      boxcolor:'red',
      index: 0
    },
    methods:{
      update: function (e) {
        modal.toast({
          'message': "don't click me",
          'duration': 0.5
        })

      }
    }
  }
</script>