
// this file is just for convenience. it sets up loading the mario obj and texture

const THREE = require('three');
require('three-obj-loader')(THREE)

export var marioTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/wahoo.bmp'), function(texture) {
        resolve(texture);
    })
})

export var silverblueTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/silverblue.bmp'), function(texture) {
        resolve(texture);
    })
})

export var caspernTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/caspern.bmp'), function(texture) {
        resolve(texture);
    })
})

export var smileTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/smilelaugh.bmp'), function(texture) {
        resolve(texture);
    })
})

export var monsterTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/green.bmp'), function(texture) {
        resolve(texture);
    })
})

export var fireTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/fire.bmp'), function(texture) {
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