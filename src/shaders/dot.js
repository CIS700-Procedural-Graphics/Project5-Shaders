
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for lambert shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true
}

export default function(renderer, scene, camera) {

    var lightDir = new THREE.Vector3(1.0,1.0,1.0);
    
    const Shader = {
        initGUI: function(gui) {

        },

        material: new THREE.ShaderMaterial({
            uniforms: {
                uLightDir: {value: lightDir}
            },
            vertexShader: require('../glsl/dot-vert.glsl'),
            fragmentShader: require('../glsl/dot-frag.glsl')
        })
    }

    return Shader;
}