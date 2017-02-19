
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for iridescent shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    a: '#2abeff',
    b: '#26e0e8',
    c: '#37ffcf',
    d: '#26e883',
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
            gui.addColor(options, 'a').onChange(function(val) {
                Shader.material.uniforms.u_a.value = new THREE.Color(val);
            });
            gui.addColor(options, 'b').onChange(function(val) {
                Shader.material.uniforms.u_b.value = new THREE.Color(val);
            });
            gui.addColor(options, 'c').onChange(function(val) {
                Shader.material.uniforms.u_c.value = new THREE.Color(val);
            });
            gui.addColor(options, 'd').onChange(function(val) {
                Shader.material.uniforms.u_d.value = new THREE.Color(val);
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
                u_a: {
                    type: 'v3',
                    value: new THREE.Color(options.a)
                },
                u_b: {
                    type: 'v3',
                    value: new THREE.Color(options.b)
                },
                u_c: {
                    type: 'v3',
                    value: new THREE.Color(options.c)
                },
                u_d: {
                    type: 'v3',
                    value: new THREE.Color(options.d)
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
                u_cameraPos: {
                  type: 'v3',
                  value: camera.position
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