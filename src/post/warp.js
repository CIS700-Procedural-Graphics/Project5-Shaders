const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 0.2
}

var WarpShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },

        gradients3d: {type: "v3v", value: [
      new THREE.Vector3(0.7071, 0.7071, 0), new THREE.Vector3(-0.7071, 0.7071, 0), new THREE.Vector3(0.7071, -0.7071, 0),
      new THREE.Vector3(-0.7071, -0.7071, 0), new THREE.Vector3(0.7071, 0, 0.7071), new THREE.Vector3(-0.7071, 0, 0.7071),
      new THREE.Vector3(0.7071, 0, -0.7071),new THREE.Vector3(-0.7071, 0, -0.7071), new THREE.Vector3(0, 0.7071, 0.7071),
      new THREE.Vector3(0, -0.7071, 0.7071),new THREE.Vector3(0 ,0.7071, -0.7071),new THREE.Vector3(0, -0.7071, -0.7071)]},

        table: {
            type: "iv1",
            value: [5,11,0,10,3,6,8,9,3,1,4,11,2,6,1,7,8,2,9,5,0,7,10,4]},
        time: {
            type: "i",
            value: Date.now()
        },
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/warp_frag.glsl')
});

export default function Warp(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(WarpShader);  

    // set this to true on the shader for your last pass to write to the screen
    WarpShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                WarpShader.material.uniforms.u_amount.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        },

        update: function() {
            WarpShader.uniforms.time.value = Date.now();
            //console.log("borf");
        }
    }
}