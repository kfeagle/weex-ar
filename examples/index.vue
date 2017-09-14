<template>
  <example-list :items="items" dir="examples"></example-list>
</template>

<script>
  module.exports = {
    data: function () {
      var root = typeof window === 'object' ? 'vue-web/vue' : ''

      return {
        items: [ 
          // common
          {name: root + '/ar', title: '渲染一个ar场景'},
          {name: root + '/dragon', title: '渲染一个恐龙'},
          {name: root + '/atapar', title: '渲染一个 可以点击的ar'},
          {name: root + '/box', title: '渲染一个物体'},
          {name: root + '/boxtap', title: '支持点击交互'},

          {name: root + '/shooter', title: '射击游戏'},


        ]
      }
    },
    components: {
      exampleList: require('./include/example-list.vue')
    },
    created: function() {
      let root = typeof window === 'object' ? 'vue-web/vue' : 'vue'
      let platform = this.$getConfig().env.platform.toLowerCase()

    }
  }
</script>
