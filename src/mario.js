
// this file is just for convenience. it sets up loading the mario obj and texture

const THREE = require('three');
require('three-obj-loader')(THREE)

export var textureLoaded = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/wahoo.bmp'), function(texture) {
        resolve(texture);
    })
})

export var objLoaded = new Promise((resolve, reject) => {
    (new THREE.OBJLoader()).load(require('./assets/wahoo.obj'), function(obj) {
        var geo = obj.children[0].geometry;
        geo.computeBoundingSphere();
        resolve(geo);
    });
})

export var matcapTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/shiny.jpg'), function(texture) {
        resolve(texture);
    })
})
