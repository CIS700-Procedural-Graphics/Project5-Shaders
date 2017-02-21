
const THREE = require('three');
import {silverblueTexture} from '../textures'
import {smileTexture} from '../textures'
import {caspernTexture} from '../textures'
import {monsterTexture} from '../textures'
import {fireTexture} from '../textures'

// options for lambert shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 1,
    ambient: '#111111',
    texture: null
}

var silver;
var smile;
var caspern;
var monster;
var fire;

export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            gui.addColor(options, 'lightColor').onChange(function(val) {
                Shader.material.uniforms.u_lightCol.value = new THREE.Color(val);
            });
            gui.add(options, 'lightIntensity').onChange(function(val) {
                Shader.material.uniforms.u_lightIntensity.value = val;
            });
            gui.addColor(options, 'ambient').onChange(function(val) {
                Shader.material.uniforms.u_ambient.value = new THREE.Color(val);
            });
            gui.addColor(options, 'ambient').onChange(function(val) {
                Shader.material.uniforms.u_ambient.value = new THREE.Color(val);
            });
            gui.add(options, 'texture', ['chrome', 'smile', 'gold', 'monster', 'fire']).onChange(function(val) {
                switch (val) {
                    case 'chrome':
                        Shader.material.uniforms.texture.value = silver;
                        break;
                    case 'smile':
                        Shader.material.uniforms.texture.value = smile;
                        break;
                    case 'monster':
                        Shader.material.uniforms.texture.value = monster;
                        break;
                    case 'fire':
                        Shader.material.uniforms.texture.value = fire;
                        break;
                    case 'gold':
                        Shader.material.uniforms.texture.value = caspern;
                }
            });
        },
        
        material: new THREE.ShaderMaterial({
            uniforms: {
                texture: {
                    type: "t", 
                    value: null
                },
                u_ambient: {
                    type: 'v3',
                    value: new THREE.Color(options.ambient)
                },
                u_lightCol: {
                    type: 'v3',
                    value: new THREE.Color(options.lightColor)
                },
                u_lightIntensity: {
                    type: 'f',
                    value: options.lightIntensity
                }
            },
            vertexShader: require('../glsl/litsphere-vert.glsl'),
            fragmentShader: require('../glsl/litsphere-frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    silverblueTexture.then(function(texture) {
        silver = texture;
        Shader.material.uniforms.texture.value = texture;
    });

    smileTexture.then(function(texture) {
        smile = texture;
    });

    caspernTexture.then(function(texture) {
        caspern = texture;
    });

    monsterTexture.then(function(texture) {
        monster = texture;
    });

    fireTexture.then(function(texture) {
        fire = texture;
    });

    return Shader;
}