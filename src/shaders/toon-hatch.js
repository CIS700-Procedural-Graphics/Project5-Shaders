
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for lambert shader
var options = {
    rotation: 0.0
};

export default function(renderer, scene, camera) {

    var lightPos = new THREE.Vector3(30, 50, 40);

    const Shader = {
        initGUI: function(gui) {
        },

        material: new THREE.ShaderMaterial({
            uniforms: {
                uLightPos: {value: lightPos}
            },
            vertexShader: require('../glsl/toon-hatch-vert.glsl'),
            fragmentShader: require('../glsl/toon-hatch-frag.glsl')
        })
    }

    return Shader;
}