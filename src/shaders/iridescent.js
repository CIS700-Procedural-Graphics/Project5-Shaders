

const THREE = require('three');
import {textureLoaded} from '../mario'

// options for iridescent shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true,
    Red_a: 0.5,
    Red_b: 0.5,
    Red_c: 1.0,
    Red_d: 0.0,
    Green_a: 0.5,
    Green_b: 0.5,
    Green_c: 1.0,
    Green_d: 0.33,
    Blue_a: 0.5,
    Blue_b: 0.5,
    Blue_c: 1.0,
    Blue_d: 0.67
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
            
            //red
            gui.add(options, 'Red_a').onChange(function(val){
                Shader.material.uniforms.u_Red_a.value = val;                               
            });
            gui.add(options, 'Red_b').onChange(function(val){
                Shader.material.uniforms.u_Red_b.value = val;                               
            });
            gui.add(options, 'Red_c').onChange(function(val){
                Shader.material.uniforms.u_Red_c.value = val;                               
            });
            gui.add(options, 'Red_d').onChange(function(val){
                Shader.material.uniforms.u_Red_d.value = val;                               
            });
            
            //green
            gui.add(options, 'Green_a').onChange(function(val){
                Shader.material.uniforms.u_Green_a.value = val;                               
            });
            gui.add(options, 'Green_b').onChange(function(val){
                Shader.material.uniforms.u_Green_b.value = val;                               
            });
            gui.add(options, 'Green_c').onChange(function(val){
                Shader.material.uniforms.u_Green_c.value = val;                               
            });
            gui.add(options, 'Green_d').onChange(function(val){
                Shader.material.uniforms.u_Green_d.value = val;                               
            });
            
            //blue
            gui.add(options, 'Blue_a').onChange(function(val){
                Shader.material.uniforms.u_Blue_a.value = val;                               
            });
            gui.add(options, 'Blue_b').onChange(function(val){
                Shader.material.uniforms.u_Blue_b.value = val;                               
            });
            gui.add(options, 'Blue_c').onChange(function(val){
                Shader.material.uniforms.u_Blue_c.value = val;                               
            });
            gui.add(options, 'Blue_d').onChange(function(val){
                Shader.material.uniforms.u_Blue_d.value = val;                               
            });
            
        },
        
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
                },
                
                //red
                u_Red_a: {
                    type: 'f',
                    value: options.Red_a
                },
                u_Red_b: {
                    type: 'f',
                    value: options.Red_b
                },
                u_Red_c: {
                    type: 'f',
                    value: options.Red_c
                },
                u_Red_d: {
                    type: 'f',
                    value: options.Red_d
                },
                
                //green
                u_Green_a: {
                    type: 'f',
                    value: options.Green_a
                },
                u_Green_b: {
                    type: 'f',
                    value: options.Green_b
                },
                u_Green_c: {
                    type: 'f',
                    value: options.Green_c
                },
                u_Green_d: {
                    type: 'f',
                    value: options.Green_d
                },
                
                //blue
                u_Blue_a: {
                    type: 'f',
                    value: options.Blue_a
                },
                u_Blue_b: {
                    type: 'f',
                    value: options.Blue_b
                },
                u_Blue_c: {
                    type: 'f',
                    value: options.Blue_c
                },
                u_Blue_d: {
                    type: 'f',
                    value: options.Blue_d
                }
                
                
            },
            vertexShader: require('../glsl/iridescent-vert.glsl'),
            fragmentShader: require('../glsl/iridescent-frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    textureLoaded.then(function(texture) {
        Shader.material.uniforms.texture.value = texture;
    });

    return Shader;
}