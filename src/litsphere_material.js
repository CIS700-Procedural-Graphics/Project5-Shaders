
// this file is just for convenience. it sets up loading the mario obj and texture

const THREE = require('three');
require('three-obj-loader')(THREE)

export var textureLoaded = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/brown.bmp'), function(texture) {
        resolve(texture);
    })
})