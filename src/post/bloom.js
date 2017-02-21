const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 3,
    brightnessThreshold: 0.8
}

var BloomShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        brightThresh: {
            type: 'f',
            value: options.brightnessThreshold
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-frag.glsl')
});

export default function Bloom(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(BloomShader);  

    // set this to true on the shader for your last pass to write to the screen
    BloomShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 8).onChange(function(val) {
                BloomShader.material.uniforms.u_amount.value = val;
            });
            gui.add(options, 'brightnessThreshold', 0, 1).onChange(function(val) {
                BloomShader.material.uniforms.brightThresh.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}
