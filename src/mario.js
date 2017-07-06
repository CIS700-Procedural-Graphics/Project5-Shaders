
// this file is just for convenience. it sets up loading the mario obj and texture

const THREE = require('three');
const prefix = './images/skymap/';
const prefix2 = './images/diffuse/';
require('three-obj-loader')(THREE)

export var textureLoaded = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/wahoo.bmp'), function(texture) {
        resolve(texture);
    })
})

export var brdfLUTLoaded = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./images/brdfLUT.png'), function(texture) {
        resolve(texture);
    })
})

export var cubemapLoaded = new Promise((resolve, reject) => {
	(new THREE.CubeTextureLoader()).load([
		require(prefix + 'px.jpg'), require(prefix + 'nx.jpg'),
		require(prefix + 'py.jpg'), require(prefix + 'ny.jpg'),
		require(prefix + 'pz.jpg'), require(prefix + 'nz.jpg')
		], 
	function(texture) { resolve(texture); })
})

export var cubemapDiffLoaded = new Promise((resolve, reject) => {
	(new THREE.CubeTextureLoader()).load([
		require(prefix2 + 'px.jpg'), require(prefix2 + 'nx.jpg'),
		require(prefix2 + 'py.jpg'), require(prefix2 + 'ny.jpg'),
		require(prefix2 + 'pz.jpg'), require(prefix2 + 'nz.jpg')
		], 
	function(texture) { resolve(texture); })
})

export var objLoaded = new Promise((resolve, reject) => {
    (new THREE.OBJLoader()).load(require('./assets/wahoo.obj'), function(obj) {
        var geo = obj.children[0].geometry;
        geo.computeBoundingSphere();
        resolve(geo);
    });
})