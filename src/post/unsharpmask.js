const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1
}

var UnsharpMaskShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'i',
            value: options.amount
        },
        u_aspectx: {
            type: 'i',
            value: window.innerWidth
        },
        u_aspecty: {
            type: 'i',
            value: window.innerHeight
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/unsharpmask-frag.glsl')
});

export default function Grayscale(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the UnsharpMaskShader
    composer.addPass(UnsharpMaskShader);

    // set this to true on the shader for your last pass to write to the screen
    UnsharpMaskShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 1, 13, 2).onChange(function(val) {
                UnsharpMaskShader.material.uniforms.u_amount.value = val;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
