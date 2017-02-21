const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1
}

var GlitchShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        u_rand: {
            type: 'fv1',
            value: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/glitch-frag.glsl')
});

export default function Glitch(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(GlitchShader);

    // set this to true on the shader for your last pass to write to the screen
    GlitchShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                GlitchShader.material.uniforms.u_amount.value = val;
            });

            var intervalID = window.setInterval(function() {
                GlitchShader.material.uniforms.u_rand.value = [
                  Math.random(),
                  Math.random(),
                  Math.random(),
                  Math.random(),
                  Math.random(),
                  Math.random()
                ];
                GlitchShader.material.needsUpdate = true;
            }, 100);
        },

        render: function() {;
            composer.render();
        }
    }
}
