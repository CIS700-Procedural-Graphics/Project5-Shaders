
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for iridecence shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true,
    sphereFile: 'smudge3.jpg',
}

/*export var textureLitsphereLoaded = new Promise((resolve, reject) => {
    (new THREE.TextureLoader()).load(require('../assets/test-texture.jpg'), function(texture) {
        resolve(texture);
    })
})*/

export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            gui.add(options, 'sphereFile', ['smudge3.jpg', 'smudge2.jpg', 'mix1.jpg', 'dry-mud.jpg', 'test-texture.jpg' ] ).onChange( function(val) {
            	Shader.material.uniforms.image.value = THREE.ImageUtils.loadTexture('./src/assets/'+val);
            });
        },
        
        material: new THREE.ShaderMaterial({
            uniforms: {
			  image: { // Check the Three.JS documentation for the different allowed types and values
				type: "t", 
				//value: THREE.ImageUtils.loadTexture('./src/assets/test-texture.jpg')
				value: THREE.ImageUtils.loadTexture('./src/assets/smudge3.jpg')
				},
                u_useTexture: {
                    type: 'i',
                    value: options.useTexture
                },
                u_albedo: {
                    type: 'v3',
                    value: new THREE.Color(options.albedo)
                },
                u_ambient: {
                    type: 'v3',
                    value: new THREE.Color(options.ambient)
                },
                u_lightPos: {
                    type: 'v3',
                    value: new THREE.Vector3(30, 50, 40)
                },
                u_lightCol: {
                    type: 'v3',
                    value: new THREE.Color(options.lightColor)
                },
                u_lightIntensity: {
                    type: 'f',
                    value: options.lightIntensity
                },
            },
            vertexShader: require('../glsl/litsphere-vert.glsl'),
            fragmentShader: require('../glsl/litsphere-frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    //textureLitsphereLoaded.then(function(texture) {
    //    Shader.material.uniforms.texture.value = texture;
    //});

    return Shader;
}