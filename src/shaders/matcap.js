
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for matcap shader
var options = {
    map: 0
}

var maps = [];
maps.push(THREE.ImageUtils.loadTexture('../spheremat1.png'));
maps.push(THREE.ImageUtils.loadTexture('../spheremat2.png'));
maps.push(THREE.ImageUtils.loadTexture('../spheremat3.png'));
maps.push(THREE.ImageUtils.loadTexture('../spheremat4.png'));
maps.push(THREE.ImageUtils.loadTexture('../spheremat5.png'));
maps.push(THREE.ImageUtils.loadTexture('../worsttextureever.png'));
var audioLoader = new THREE.AudioLoader();
var listener = new THREE.AudioListener();
var sound = new THREE.Audio(listener);

export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            
            gui.add(options, 'map', 0, 5).step(1).onChange(function(val) {
                Shader.material.uniforms.matcap.value = maps[val];

                if (val == 5) {
                    renderer.setClearColor(0x000000, 1.0);
                    camera.add(listener);

                    //Load a sound and set it as the Audio object's buffer
                    audioLoader.load( '../endofallthings.mp3', function(buffer) {
                        sound.setBuffer(buffer);
                        sound.setLoop(false);
                        sound.setVolume(1.0);
                        sound.play();
                        alert("IT'S TOO LATE");

                    }); 
                } else {
                    renderer.setClearColor(0x999999, 1.0);
                }

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