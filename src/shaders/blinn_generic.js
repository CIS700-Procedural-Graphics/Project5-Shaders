


const THREE = require('three');
import {textureLoaded} from '../mario'

const DEG2RAD = 0.0174533;
var ShaderRef;
//new THREE.Vector3(Math.sin(settings.yaw) * Math.cos(settings.pitch)
    //, Math.sin(settings.pitch), Math.cos(settings.yaw)  * Math.cos(settings.pitch));
var PH_lightTypes = [0, 5, 6, 8];
// options for lambert shader
var options = {

    albedo: '#dddddd',
    specColor: '#ffffff',
    specExponent: 64,
    ambient: '#111620',
    useTexture: true,

    exposure: 1.0,

    randomize: function(){
        var newValues = [];
        //console.log(ShaderRef);
        var outputString = "Adding new lights: \n";
        for (var i = 0; i < 5; i++) {
            var light = new Object();
            light.location = new THREE.Vector3(Math.random() * 20.0 - 10.0,
                Math.random() * 40.0,
                Math.random() * 20.0 - 10.0);
            var lookAt = new THREE.Vector3(0.0, Math.random() * 20.0, 0.0);
            
            light.direction = lookAt.subVectors(lookAt, light.location).normalize();
            light.type = PH_lightTypes[Math.floor(Math.random() * PH_lightTypes.length)];
            light.intensity = Math.random() * 20.0;
            light.color = new THREE.Color(Math.random(), Math.random(), Math.random());
            light.intensity2 = 0.0;
            light.color2 = new THREE.Color(0.0, 0.0, 0.0);
            
            var outer = Math.random() * 90.0;
            light.inner = Math.random() * outer;
            light.outer = outer;

            var lString = "";
            if (light.type == 0) {
                lString = "Off";
            } else if (light.type == 5) {
                lString = "Point";
            } else if (light.type == 6) {
                lString = "Spot";
            } else if (light.type == 8) {
                lString = "Distant";
            }

            if (light.type !== 0) {
                lString += " intensity: " + light.intensity.toPrecision(4);
            }
            outputString += lString + "\n";
            newValues.push(light);
        }
        console.log(outputString);
        if (ShaderRef !== undefined) {
            //if (ShaderRef.uniforms !== undefined) {
                ShaderRef.material.uniforms.u_lights.value = newValues;
            //} else console.log("uniforms undefined");
            
        } else console.log("shader undefined");
    }

}


export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {

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

            gui.add(options, 'randomize');
            
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
                u_lights: {
                    value: [], 
                    properties: {
                        location: {},
                        direction: {},
                        type: {},
                        intensity: {},
                        color: {},
                        intensity2: {},
                        color2: {},
                        inner: {},
                        outer: {}
                    }
                }
                
            },
            vertexShader: require('../glsl/blinn_vert.glsl'),
            fragmentShader: require('../glsl/blinn_generic_frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    textureLoaded.then(function(texture) {
        Shader.material.uniforms.texture.value = texture;
    });

    ShaderRef = Shader;
    options.randomize();
    return Shader;
}