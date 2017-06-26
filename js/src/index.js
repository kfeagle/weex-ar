

const WeexAr = {
  show() {
      alert("module WeexAr is created sucessfully ")
  }
};


var meta = {
   WeexAr: [{
    name: 'show',
    args: []
  }]
};



if(window.Vue) {
  weex.registerModule('WeexAr', WeexAr);
}

function init(weex) {
  weex.registerApiModule('WeexAr', WeexAr, meta);
}
module.exports = {
  init:init
};
