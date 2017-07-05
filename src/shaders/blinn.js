
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for lambert shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    specColor: '#ffffff',
    specExponent: 64,
    ambient: '#111620',
    useTexture: true,


    directionalDirectionX: 0.0,
    directionalDirectionY: -1.0,
    directionalDirectionZ: 0.0,
    directionalColor: '#ffeedd',
    directionalIntensity: 2,

    pointX: 10.0,
    pointY: 10.0,
    pointZ: 10.0,
    exposure: 1.0,
    gamma: 2.2
}

function NormalizeDirectional() {
    var len = options.directionalDirectionZ * options.directionalDirectionZ +
    options.directionalDirectionY * options.directionalDirectionY +
    options.directionalDirectionX * options.directionalDirectionX;

    len = Math.sqrt(len);
    options.directionalDirectionX /= len;
    options.directionalDirectionY /= len;
    options.directionalDirectionZ /= len;
}

export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            // directional light
            var f2 = gui.addFolder('DirectionalLight');

            f2.addColor(options, 'directionalColor').onChange(function(val) {
                Shader.material.uniforms.u_lightCol.value = new THREE.Color(val);
            });
            f2.add(options, 'directionalIntensity').min(0).onChange(function(val) {
                Shader.material.uniforms.u_dirLightIntensity.value = val;
            });
            f2.add(options, 'directionalDirectionX', -1, 1, 0.1).listen().onChange(function(val) {
                options.directionalDirectionX = val;
                NormalizeDirectional();
                Shader.material.uniforms.u_dirLightDirection.value = new THREE.Vector3(options.directionalDirectionX, options.directionalDirectionY, options.directionalDirectionZ);
            });
            f2.add(options, 'directionalDirectionY', -1, 1, 0.1).listen().onChange(function(val) {
                options.directionalDirectionY = val;
                NormalizeDirectional();
                Shader.material.uniforms.u_dirLightDirection.value = new THREE.Vector3(options.directionalDirectionX, options.directionalDirectionY, options.directionalDirectionZ);
            });
            f2.add(options, 'directionalDirectionZ', -1, 1, 0.1).listen().onChange(function(val) {
                options.directionalDirectionZ = val;
                NormalizeDirectional();
                Shader.material.uniforms.u_dirLightDirection.value = new THREE.Vector3(options.directionalDirectionX, options.directionalDirectionY, options.directionalDirectionZ);
            });



            // point lights
            var f1 = gui.addFolder('PointLight')

            f1.addColor(options, 'lightColor').onChange(function(val) {
                Shader.material.uniforms.u_lightCol.value = new THREE.Color(val);
            });
            f1.add(options, 'lightIntensity').min(0).onChange(function(val) {
                Shader.material.uniforms.u_lightIntensity.value = val;
            });
            

            f1.add(options, 'pointX').onChange(function(val) {

                Shader.material.uniforms.u_lightPos.value = new THREE.Vector3(val, options.pointY, options.pointZ);
            });
            f1.add(options, 'pointY').onChange(function(val) {

                Shader.material.uniforms.u_lightPos.value = new THREE.Vector3(options.pointX, val, options.pointZ);
            });
            f1.add(options, 'pointZ').onChange(function(val) {

                Shader.material.uniforms.u_lightPos.value = new THREE.Vector3(options.pointZ, options.pointY, val);
            });


            // material properties
            gui.addColor(options, 'albedo').onChange(function(val) {
                Shader.material.uniforms.u_albedo.value = new THREE.Color(val);
            });

            gui.addColor(options, 'ambient').onChange(function(val) {
                Shader.material.uniforms.u_ambient.value = new THREE.Color(val);
            });
            gui.add(options, 'useTexture').onChange(function(val) {
                Shader.material.uniforms.u_useTexture.value = val;
            });

            gui.add(options, 'gamma').onChange(function(val) {
                Shader.material.uniforms.u_gamma.value = val;
            });
            gui.add(options, 'exposure').onChange(function(val) {
                Shader.material.uniforms.u_exposure.value = val;
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
                u_gamma: {
                    type: 'f',
                    value: options.gamma
                },
                u_exposure: {
                    type: 'f',
                    value: options.exposure
                },
                u_specularColor: {
                    type: 'v3',
                    value: new THREE.Color(options.specColor)
                },
                u_specularExponent: {
                    type: 'f',
                    value: options.specExponent
                },
                u_dirLightIntensity: {
                    type: 'f',
                    value: options.directionalIntensity
                },
                u_dirLightDirection: {
                    type: 'v3',
                    value: new THREE.Vector3(options.directionalDirectionX, options.directionalDirectionY, options.directionalDirectionZ)
                },
                u_dirLightCol: {
                    type: 'v3',
                    value: new THREE.Color(options.directionalColor)
                }
            },
            vertexShader: require('../glsl/blinn_vert.glsl'),
            fragmentShader: require('../glsl/blinn_frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    textureLoaded.then(function(texture) {
        Shader.material.uniforms.texture.value = texture;
    });

    return Shader;
}