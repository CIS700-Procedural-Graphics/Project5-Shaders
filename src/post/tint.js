const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

let options = {
    amount:0.2,
    color: '#000000'
};

let TintShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        u_tint: {
          type: 'v3',
          value: new THREE.Color(options.color)
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/tint-frag.glsl')
});

export default function Tint(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    let composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the TintShader
    composer.addPass(TintShader);

    // set this to true on the shader for your last pass to write to the screen
    TintShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                TintShader.material.uniforms.u_amount.value = val;
            });
            gui.addColor(options, 'color').onChange(function(val) {
                TintShader.material.uniforms.u_tint.value = new THREE.Color(val);
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
