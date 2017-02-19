const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 4
}

var GaussianblurShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_radius: {
            type: 'f',
            value: options.amount
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/gaussianblur-frag.glsl')
});

export default function Gaussianblur(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GaussianblurShader
    composer.addPass(GaussianblurShader);

    // set this to true on the shader for your last pass to write to the screen
    GaussianblurShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 2, 10).onChange(function(val) {
                GaussianblurShader.material.uniforms.u_radius.value = val;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}