
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for lambert shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true,
    width: 1,
    top: 20.0,
    bottom: -5.0,
    pause: false
}
var clock = new THREE.Clock();
var t = 0.0;

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
            gui.add(options, 'width', 0, 3).onChange(function(val) {
                Shader.material.uniforms.u_edgeWidth.value = val;
            });
            gui.add(options, 'top', 5.0, 25.0).onChange(function(val) {
                Shader.material.uniforms.topEdge.value = val;
            });
            gui.add(options, 'bottom', -15.0, 5.0).onChange(function(val) {
                Shader.material.uniforms.botEdge.value = val;
            });
            gui.add(options, 'pause');
        },

        update: function() {
            var a = clock.getDelta();
            
            if (!options.pause) {
                t += a;
                Shader.material.uniforms.time.value = t;
            }
            
        },
        
        material: new THREE.ShaderMaterial({
            uniforms: {
                texture: {
                    type: "t", 
                    value: null
                },
                disintegrate: {
                    type: 't',
                    value: THREE.ImageUtils.loadTexture(require('../assets/anisotropic.png'))
                },
                ramp: {
                    type: 't',
                    value: THREE.ImageUtils.loadTexture(require('../assets/ramp.png'))
                },
                noise: {
                    type: 't',
                    value: THREE.ImageUtils.loadTexture(require('../assets/perlin.png'))
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
                u_edgeWidth: {
                    type: 'f',
                    value: options.width
                },
                topEdge: {
                    type: 'f',
                    value: options.top
                },
                botEdge: {
                    type: 'f',
                    value: options.bottom
                },
                time : {
                    type: 'f',
                    value: t
                }
            },
            vertexShader: require('../glsl/toon-vert.glsl'),
            fragmentShader: require('../glsl/teleport.glsl')
        })
    }
    var gl = renderer.context;
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    Shader.material.side = THREE.DoubleSide;
    Shader.material.blending = THREE.NormalBlending;
    // once the Mario texture loads, bind it to the material
    textureLoaded.then(function(texture) {
        Shader.material.uniforms.texture.value = texture;
    });

    return Shader;
}