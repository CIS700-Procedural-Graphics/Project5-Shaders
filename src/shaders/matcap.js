
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for matcap shader
var options = {
    map: 0
}

var maps = [];
maps.push(THREE.ImageUtils.loadTexture('../spheremat1.png'));
maps.push(THREE.ImageUtils.loadTexture('../spheremat4.png'));
maps.push(THREE.ImageUtils.loadTexture('../spheremat5.png'));
maps.push(THREE.ImageUtils.loadTexture('../worsttextureever.png'));

export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            
            gui.add(options, 'map', 0, 3).step(1).onChange(function(val) {
                Shader.material.uniforms.matcap.value = maps[val];
            });
            
        },
        
        material: new THREE.ShaderMaterial({
            uniforms: {
                matcap: {
                    type: "t", 
                    value: null
                }
            },
            vertexShader: require('../glsl/matcap_vert.glsl'),
            fragmentShader: require('../glsl/matcap_frag.glsl')
        })


    }

    textureLoaded.then(function(texture) {
        Shader.material.uniforms.matcap.value = maps[0];
    });
    return Shader;
}