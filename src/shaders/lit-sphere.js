
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

    
    var bluegreen = THREE.ImageUtils.loadTexture('src/assets/sphere-textures/bluegreen.jpg');
    var colorwheel = THREE.ImageUtils.loadTexture('src/assets/sphere-textures/colorwheel.png');
    var bronze = THREE.ImageUtils.loadTexture('src/assets/sphere-textures/bronze.jpg');
    var chrome = THREE.ImageUtils.loadTexture('src/assets/sphere-textures/chrome.jpg');
    var red = THREE.ImageUtils.loadTexture('src/assets/sphere-textures/red.jpg');
    var slime = THREE.ImageUtils.loadTexture('src/assets/sphere-textures/slime.jpg');



    var selectedTexture = {
        texture: 'bluegreen'
    };

    var textureMap = {
        'bluegreen' : bluegreen,
        'colorwheel' : colorwheel,
        'bronze': bronze,
        'chrome': chrome,
        'red': red,
        'slime': slime
    };

    var sphereTexture = bluegreen;

    
    const Shader = {
        initGUI: function(gui) {
            gui.add(selectedTexture, 'texture', ['bluegreen','slime', 'bronze', 'colorwheel', 'chrome', 'red'] ).onChange(function(val){
                Shader.material.uniforms.uSphereTexture.value = textureMap[val];
            });
        },

        material: new THREE.ShaderMaterial({
            uniforms: {
                uSphereTexture: {
                    type: "t", 
                    value: sphereTexture                },
            },
            vertexShader: require('../glsl/lit-sphere-vert.glsl'),
            fragmentShader: require('../glsl/lit-sphere-frag.glsl')
        })
    }

    return Shader;
}