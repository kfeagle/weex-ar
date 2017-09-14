<template>
  <div>
    <text style="font-size: 40px;" >weex 渲染一个可以点击的矩形</text>
    <ar ref="scene" style="height: 1100;width: 750" @click="update" debug="false" >
      <box style="x:0.1;y:0.1;z:-0.5;width: 0.1;height: 0.1;length:0.1;chamfererRadius:0;" :style="{ color: boxcolor }"> </box>
    </ar>
  </div>
</template>

<script>
  module.exports = {
    data: {
      boxcolor:'red',
      index: 0
    },
    methods:{
      update: function (e) {
        console.log(e)
        if(e.key){
          var s = e.key
          var node =  weex.document.getRef(e.key)
          console.log('jerry')
          console.log(e.key)
          console.log(node)
          this.index = this.index+1;
          if(this.index>3){
            this.index = 0;
          }
          if(this.index == 1){
            node.setStyle('color','blue',false)
          }
          if(this.index == 2){
            node.setStyle('color','green',false)
          }
          if(this.index == 3){
            node.setStyle('color','yellow',false)
          }
        }
      }
    }
  }
</script>