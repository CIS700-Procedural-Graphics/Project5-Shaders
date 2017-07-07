


const THREE = require('three');
import {textureLoaded} from '../mario'

const DEG2RAD = 0.0174533;
//new THREE.Vector3(Math.sin(settings.yaw) * Math.cos(settings.pitch)
    //, Math.sin(settings.pitch), Math.cos(settings.yaw)  * Math.cos(settings.pitch));

// options for lambert shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    specColor: '#ffffff',
    specExponent: 64,
    ambient: '#111620',
    useTexture: true,

    directionalYaw: 180.0,
    directionalPitch: -90.0,
    directionalColor: '#ffeedd',
    directionalIntensity: 2,

    pointX: 10.0,
    pointY: 10.0,
    pointZ: 10.0,

    spotX: 10.0,
    spotY: 10.0,
    spotZ: 10.0,
    spotYaw: 225.0,
    spotPitch: 0.0,
    spotColor: '#ffeedd',
    spotIntensity: 2,
    spotInner: 0.2,
    spotOuter: 0.3,

    areaWidth: 1.0,
    areaHeight: 1.0,
    areaPosX: 0.0,
    areaPosY: 10.0,
    areaPosZ: 10.0,
    areaPitch: 0.0,
    areaYaw: 180.0,
    areaColor: '#ffffff',
    areaIntensity: 2.0,

    exposure: 1.0,
    gamma: 2.2
}


export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            // directional light
            var f2 = gui.addFolder('DirectionalLight');

            f2.addColor(options, 'directionalColor').onChange(function(val) {
                Shader.material.uniforms.u_dirLightCol.value = new THREE.Color(val);
            });

            f2.add(options, 'directionalIntensity').min(0).onChange(function(val) {
                Shader.material.uniforms.u_dirLightIntensity.value = val;
            });

            f2.add(options, 'directionalPitch', -90, 90).listen().onChange(function(val) {
                Shader.material.uniforms.u_dirLightDirection.value = new THREE.Vector3(
                    Math.sin(DEG2RAD * options.directionalYaw) * Math.cos(DEG2RAD * options.directionalPitch), 
                    Math.sin(DEG2RAD * options.directionalPitch), 
                    Math.cos(DEG2RAD * options.directionalYaw) * Math.cos(DEG2RAD * options.directionalPitch));
            });

            f2.add(options, 'directionalYaw', 0, 360).listen().onChange(function(val) {
                Shader.material.uniforms.u_dirLightDirection.value = new THREE.Vector3(
                    Math.sin(DEG2RAD * options.directionalYaw) * Math.cos(DEG2RAD * options.directionalPitch), 
                    Math.sin(DEG2RAD * options.directionalPitch), 
                    Math.cos(DEG2RAD * options.directionalYaw) * Math.cos(DEG2RAD * options.directionalPitch));
            });


            // point lights
            
            var f1 = gui.addFolder('PointLight');

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

                Shader.material.uniforms.u_lightPos.value = new THREE.Vector3(options.pointX, options.pointY, val);
            });


            // spot light
            var f3 = gui.addFolder('SpotLight');

            f3.addColor(options, 'spotColor').onChange(function(val) {
                Shader.material.uniforms.u_spotCol.value = new THREE.Color(val);
            });
            f3.add(options, 'spotIntensity').min(0).onChange(function(val) {
                Shader.material.uniforms.u_spotIntensity.value = val;
            });
            f3.add(options, 'spotX').onChange(function(val) {
                Shader.material.uniforms.u_spotPos.value = new THREE.Vector3(val, options.spotY, options.spotZ);
            });
            f3.add(options, 'spotY').onChange(function(val) {
                Shader.material.uniforms.u_spotPos.value = new THREE.Vector3(options.spotX, val, options.spotZ);
            });
            f3.add(options, 'spotZ').onChange(function(val) {
                Shader.material.uniforms.u_spotPos.value = new THREE.Vector3(options.spotX, options.spotY, val);
            });


            f3.add(options, 'spotPitch', -90, 90).listen().onChange(function(val) {
                Shader.material.uniforms.u_spotDir.value = new THREE.Vector3(
                    Math.sin(DEG2RAD * options.spotYaw) * Math.cos(DEG2RAD * options.spotPitch), 
                    Math.sin(DEG2RAD * options.spotPitch), 
                    Math.cos(DEG2RAD * options.spotYaw) * Math.cos(DEG2RAD * options.spotPitch));
            });

            f3.add(options, 'spotYaw', 0, 360).listen().onChange(function(val) {
                Shader.material.uniforms.u_spotDir.value = new THREE.Vector3(
                    Math.sin(DEG2RAD * options.spotYaw) * Math.cos(DEG2RAD * options.spotPitch), 
                    Math.sin(DEG2RAD * options.spotPitch), 
                    Math.cos(DEG2RAD * options.spotYaw) * Math.cos(DEG2RAD * options.spotPitch));
            });
            f3.add(options, 'spotInner', 0.0, 1.0).listen().onChange(function(val) {
                if (val >= options.spotOuter) options.spotOuter = val;
                Shader.material.uniforms.u_spotInner.value = val;
                Shader.material.uniforms.u_spotOuter.value = options.spotOuter;
                //if (val >= options.spotOuter) Shader.material.uniforms.u_spotOuter = val;
            });
            f3.add(options, 'spotOuter', 0.0, 1.0).listen().onChange(function(val) {
                if (val <= options.spotInner) options.spotInner = val;
                Shader.material.uniforms.u_spotOuter.value = val;
                Shader.material.uniforms.u_spotInner.value = options.spotInner;
                //if (val <= options.spotInner) Shader.material.uniforms.u_spotInner = val;
            });

            var f4 = gui.addFolder('AreaLight');
             f4.add(options, 'areaPitch', -90, 90).listen().onChange(function(val) {
                Shader.material.uniforms.u_areaDir.value = new THREE.Vector3(
                    Math.sin(DEG2RAD * options.areaYaw) * Math.cos(DEG2RAD * options.areaPitch), 
                    Math.sin(DEG2RAD * options.areaPitch), 
                    Math.cos(DEG2RAD * options.areaYaw) * Math.cos(DEG2RAD * options.areaPitch));
            });

            f4.add(options, 'areaYaw', 0, 360).listen().onChange(function(val) {
                Shader.material.uniforms.u_areaDir.value = new THREE.Vector3(
                    Math.sin(DEG2RAD * options.areaYaw) * Math.cos(DEG2RAD * options.areaPitch), 
                    Math.sin(DEG2RAD * options.areaPitch), 
                    Math.cos(DEG2RAD * options.areaYaw) * Math.cos(DEG2RAD * options.areaPitch));
            });

            f4.addColor(options, 'areaColor').onChange(function(val) {
                Shader.material.uniforms.u_areaCol.value = new THREE.Color(val);
            });

            f4.add(options, 'areaIntensity').min(0).onChange(function(val) {
                Shader.material.uniforms.u_areaIntensity.value = val;
            });

            f4.add(options, 'areaPosX').onChange(function(val) {
                Shader.material.uniforms.u_areaPos.value = new THREE.Vector3(val, options.areaPosY, options.areaPosZ);
            });
            f4.add(options, 'areaPosY').onChange(function(val) {
                Shader.material.uniforms.u_areaPos.value = new THREE.Vector3(options.areaPosX, val, options.areaPosZ);
            });
            f4.add(options, 'areaPosZ').onChange(function(val) {
                Shader.material.uniforms.u_areaPos.value = new THREE.Vector3(options.areaPosX, options.areaPosY, val);
            });


            f4.add(options, 'areaWidth').min(0.1).onChange(function(val) {
                Shader.material.uniforms.u_areaWidth.value = val;
            });
            f4.add(options, 'areaHeight').min(0.1).onChange(function(val) {
                Shader.material.uniforms.u_areaHeight.value = val;
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

            gui.add(options, 'exposure').min(0).onChange(function(val) {
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
                    value: new THREE.Vector3(10, 10, 10)
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
                    value: new THREE.Vector3(
                    Math.sin(DEG2RAD * options.directionalYaw) * Math.cos(DEG2RAD * options.directionalPitch), 
                    Math.sin(DEG2RAD * options.directionalPitch), 
                    Math.cos(DEG2RAD * options.directionalYaw) * Math.cos(DEG2RAD * options.directionalPitch))
                },

                u_dirLightCol: {
                    type: 'v3',
                    value: new THREE.Color(options.directionalColor)
                },

                u_spotCol: {
                    type: 'v3',
                    value: new THREE.Color(options.spotColor)
                },

                u_spotDir: {
                    type: 'v3',
                    value: new THREE.Vector3(
                    Math.sin(DEG2RAD * options.spotYaw) * Math.cos(DEG2RAD * options.spotPitch), 
                    Math.sin(DEG2RAD * options.spotPitch), 
                    Math.cos(DEG2RAD * options.spotYaw) * Math.cos(DEG2RAD * options.spotPitch))
            
                },

                u_spotPos: {
                    type: 'v3',
                    value: new THREE.Vector3(options.spotX, options.spotY, options.spotZ)
                },

                u_spotIntensity: {
                    type: 'f',
                    value: options.spotIntensity
                },

                u_spotInner: {
                    type: 'f',
                    value: options.spotInner
                },
                u_spotOuter: {
                    type: 'f',
                    value: options.spotOuter
                },
                u_areaWidth: {
                    type: 'f',
                    value: options.areaWidth
                },
                u_areaHeight: {
                    type: 'f',
                    value: options.areaHeight
                },
                u_areaPos: {
                    type: 'v3',
                    value: new THREE.Vector3(options.areaPosX, options.areaPosY, options.areaPosZ)
                },
                u_areaDir: {
                    type: 'v3',
                    value: new THREE.Vector3(
                    Math.sin(DEG2RAD * options.areaYaw) * Math.cos(DEG2RAD * options.areaPitch), 
                    Math.sin(DEG2RAD * options.areaPitch), 
                    Math.cos(DEG2RAD * options.areaYaw) * Math.cos(DEG2RAD * options.areaPitch))
            
                },
                u_areaIntensity: {
                    type: 'f',
                    value: options.areaIntensity
                },
                u_areaCol: {
                    type: 'v3',
                    value: new THREE.Color(options.areaColor)
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