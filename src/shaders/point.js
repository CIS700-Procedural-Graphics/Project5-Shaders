
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
    
    const Shader = {
        initGUI: function(gui) {
            gui.addColor(options, 'lightColor').onChange(function(val) {
                Shader.material.uniforms.u_lightCol.value = new THREE.Color(val);
            });
            gui.add(options, 'lightIntensity').onChange(function(val) {
                Shader.material.uniforms.u_lightIntensity.value = val;
            });
            gui.addColor(options, 'albedo').onChange(function(val) {
                Shader.material.uniforms.u_albedo.value = new THREE.Color(val);
            });
            gui.addColor(options, 'ambient').onChange(function(val) {
                Shader.material.uniforms.u_ambient.value = new THREE.Color(val);
            });
            gui.add(options, 'useTexture').onChange(function(val) {
                Shader.material.uniforms.u_useTexture.value = val;
            });
        },
        
        // all worlspace shaders should have a material 
        // this is the shader material used in project 1
        // all uniform values are used. 
        material: new THREE.ShaderMaterial({
            uniforms: {
                texture: {
                    type: "t", 
                    value: null
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
                }
            },
            vertexShader: require('../glsl/point-vert.glsl'),
            fragmentShader: require('../glsl/point-frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    textureLoaded.then(function(texture) {
        Shader.material.uniforms.texture.value = texture;
    });

    return Shader;
}