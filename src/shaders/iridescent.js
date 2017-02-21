
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for lambert shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true,

    Repeat: 1.0,

    RedYShift: 0.0,
    RedAmplitude: 0.5,
    RedFrequency: 1.0,
    RedPhase: -1.0,

    GreenYShift: 0.0,
    GreenAmplitude: 0.5,
    GreenFrequency: 1.0,
    GreenPhase: 1.0,

    BlueYShift: 1.0,
    BlueAmplitude: 0.5,
    BlueFrequency: 1.0,
    BluePhase: 0.66
}

export default function(renderer, scene, camera) {

    const Shader = {
        initGUI: function(gui) {
            gui.add(options, 'Repeat', 1.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_repeat.value = val;
            });
            gui.add(options, 'RedYShift', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_red.value.x = val;
            });
            gui.add(options, 'RedAmplitude', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_red.value.y = val;
            });
            gui.add(options, 'RedFrequency', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_red.value.z = val;
            });
            gui.add(options, 'RedPhase', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_red.value.w = val;
            });
            gui.add(options, 'GreenYShift', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_green.value.x = val;
            });
            gui.add(options, 'GreenAmplitude', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_green.value.y = val;
            });
            gui.add(options, 'GreenFrequency', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_green.value.z = val;
            });
            gui.add(options, 'GreenPhase', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_green.value.w = val;
            });
            gui.add(options, 'BlueYShift', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_blue.value.x = val;
            });
            gui.add(options, 'BlueAmplitude', -2.0, 2.0).onChange(function(val) {
                Shader.material.uniforms.u_blue.value.y = val;
            });
            gui.add(options, 'BlueFrequency').onChange(function(val) {
                Shader.material.uniforms.u_blue.value.z = val;
            });
            gui.add(options, 'BluePhase').onChange(function(val) {
                Shader.material.uniforms.u_blue.value.w = val;
            });
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
                u_repeat: {
                    type: 'f',
                    value: options.Repeat
                },
                u_red: {
                    type: 'v4',
                    value: new THREE.Vector4(0.0, 0.5, 1.0, -1.0)
                },
                u_green: {
                    type: 'v4',
                    value: new THREE.Vector4(0.0, 0.5, 1.0, 1.0)
                },
                u_blue: {
                    type: 'v4',
                    value: new THREE.Vector4(0.0, 0.5, 1.0, 0.66)
                }
                // u_cameraPos: {
                //     type: 'v3',
                //     value: camera.position
                // }
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
