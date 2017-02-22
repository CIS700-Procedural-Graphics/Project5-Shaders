const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1
}

// all postprocess shaders MUST have uniform called tDiffuse
// tDiffuse is texture which it renders the frame to. 
var GrayscaleShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            // this is the amount of gray that I want to apply. when you want to modify the
            // value, you need to say GrayscaleShader.material.uniforms.u_amount.value 
            value: options.amount
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/hatch-frag.glsl')
});

// using the three effect composer. ok. 
// all shaders get initialized to renderer, scene, camera. i.e. for toon shading you need camera 
export default function Grayscale(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(GrayscaleShader);  

    // set this to true on the shader for your last pass to write to the screen
    GrayscaleShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                GrayscaleShader.material.uniforms.u_amount.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}