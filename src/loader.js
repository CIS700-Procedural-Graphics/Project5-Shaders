
// this file is just for convenience. it sets up loading the mario obj and texture
const THREE = require('three');
const NUM_MATS = 7;
require('three-obj-loader')(THREE)

export let textureLoaded = new Promise((resolve, reject) => {
  (new THREE.TextureLoader()).load(require('./assets/wahoo.bmp'), function(texture) {
    resolve(texture);
  });
});

export let objLoaded = new Promise((resolve, reject) => {
  (new THREE.OBJLoader()).load(require('./assets/wahoo.obj'), function(obj) {
    let geo = obj.children[0].geometry;
    geo.computeBoundingSphere();
    resolve(geo);
  });
});

export let matLoaded = Promise.all([...Array(NUM_MATS).keys()].map(i => {
  return new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require(`./assets/${i}.bmp`), function(texture) {
      resolve(texture);
    });
  });
}));
