
// this file is just for convenience. it sets up loading the mario obj and texture

const THREE = require('three');
require('three-obj-loader')(THREE)

export var textureLoaded = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/wahoo.bmp'), function(texture) {
        resolve(texture);
    })
})

export var objLoaded = new Promise((resolve, reject) => {
    (new THREE.OBJLoader()).load(require('./assets/venus.obj'), function(obj) {
        var geo = obj.children[0].geometry;

        //--------------------------------
        // Modifications to compute smooth normals for objs that don't come with that info
        // http://stackoverflow.com/questions/35136282/how-to-smooth-mesh-triangles-in-stl-loaded-buffergeometry
		var attrib = geo.getAttribute('position');
        if(attrib === undefined) {
            throw new Error('a given BufferGeometry object must have a position attribute.');
        }
        var positions = attrib.array;
        var vertices = [];
        for(var i = 0, n = positions.length; i < n; i += 3) {
            var x = positions[i];
            var y = positions[i + 1];
            var z = positions[i + 2];
            vertices.push(new THREE.Vector3(x, y, z));
        }
        var faces = [];
        for(var i = 0, n = vertices.length; i < n; i += 3) {
            faces.push(new THREE.Face3(i, i + 1, i + 2));
        }

        var geometry = new THREE.Geometry();
        geometry.vertices = vertices;
        geometry.faces = faces;
        geometry.computeFaceNormals();
        geometry.mergeVertices()
        geometry.computeVertexNormals();
        geometry.computeBoundingSphere();
        geometry.center();

        resolve(geometry);
    });
})

export var matcapTexture = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('./assets/cloudy.png'), function(texture) {
        resolve(texture);
    })
})
