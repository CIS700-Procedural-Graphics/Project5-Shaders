
const THREE = require('three');
import {textureLoaded, matLoaded} from '../loader'

// options for ramp shader
let options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true,
    mat: 'Tarnished'
}

let mat = {};
let materials = ['Tarnished', 'Metal', 'Clay', 'Brass', 'Plastic', 'Marble', 'Shiny'];

export default function(renderer, scene, camera) {

    const Shader = {
      initGUI: function(gui) {
        gui.add(options, 'mat', materials).onChange(function (val) {
          Shader.material.uniforms.matTexture.value = mat[val];
        });
      },

      material: new THREE.ShaderMaterial({
        uniforms: {
          matTexture: {
            type: "t",
            value: null
          },
          u_lightPos: {
            type: 'v3',
            value: new THREE.Vector3(30, 50, 40)
          },
          u_viewPos: {
            type: 'v3',
            value: camera.position
          }
        },
        vertexShader: require('../glsl/lit-vert.glsl'),
        fragmentShader: require('../glsl/lit-frag.glsl')
      })
    }

    matLoaded.then(textures => {
      textures.forEach((t, i) => {
        mat[i] = t;
      });
      // aliasing
      materials.forEach((m, i) => {
        mat[m] = mat[i]
      });
      Shader.material.uniforms.matTexture.value = mat[options.mat];
    });

    return Shader;
}
