<template>
    <div>
        <text style="font-size: 60px;" @click="add">射中{{record}}</text>
        <scene ref="scene" style="height: 1100;width: 750" @tap="tap" @contact="contact" @removeNode="removeNode"></scene>
    </div>
</template>

<script>
    var modal = weex.requireModule('modal')
    module.exports = {
        data: function () {
            return {
                isAdd:true,
                record:0,
                ship: {
                    name: 'ship',
                    width: 0.1,
                    height: 0.1,
                    length: 0.1,
                    PhysicsBodyType: 1,
                    affectedByGravity: false,
                    categoryBitMask: 0,
                    contactTestBitMask: 1,
                    chamferRadius: 0,
                    materialsCount: 6,
                    vector: {
                        x: Math.random(),
                        y: Math.random(),
                        z: -1
                    },
                    contents: {
                        type: 'image',
                        src: 'https://github.com/kfeagle/firstdemo/blob/master/taobao.jpg?raw=true'
                    }
                },
                ball: {
                    name:'ball',
                    type:'sphere',
                    radius:'0.025',
                    categoryBitMask:1,
                    contactTestBitMask:0,
                    PhysicsBodyType:1,
                    affectedByGravity:false,
                    contents:{
                        type:'image',
                        src:'https://github.com/kfeagle/firstdemo/blob/master/bullet.jpg?raw=true'
                    },
                },

            };
        },
        mounted: function () {
            console.log('Data observation finished')
            this.$refs['scene'].addNode(this.ship
            );
        },
        methods: {
            tap:function (event) {
                this.$refs['scene'].addNode(this.ball);
            },
            contact:function (event) {
                if(event.nodes.nodeA.mask == 0 || event.nodes.nodeB.mask == 0 ){

                    this.isAdd = false;
                    this.$refs['scene'].removeNode(event.nodes.nodeA.name);
                    this.$refs['scene'].removeNode(event.nodes.nodeB.name);
                    this.ship.vector.x = Math.random();
                    this.ship.vector.y = Math.random();

                }

            },
            removeNode:function (event) {
                if(event.node.name == 'ship' ){
                    var self = this;
                    if(!self.isAdd){
                        self.$refs['scene'].addNode(self.ship);
                        self.isAdd = true;
                        this.record = this.record+1;
                        if(this.record%5 == 0 ){
                            modal.toast({ message: "你已经射中 "+this.record+ "个，牛，休息一下:-)" })
                        }

                    }
                }

            }
        }
    }
</script>