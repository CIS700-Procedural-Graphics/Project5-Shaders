const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
  exposure: 1.0,
  gamma: 2.2
}

var LinearToneMapping = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_exposure: {
            type: 'f',
            value: options.exposure
        },
        u_gamma: {
            type: 'f',
            value: options.gamma
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/lineartone-frag.glsl')
});

export default function LinearToneFilter(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(LinearToneMapping);

    // set this to true on the shader for your last pass to write to the screen
    LinearToneMapping.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'exposure', 0.1, 2.0).onChange(function(val) {
                LinearToneMapping.material.uniforms.u_exposure.value = val;
            });

            gui.add(options, 'gamma', 0.5, 3.0).onChange(function(val) {
                LinearToneMapping.material.uniforms.u_gamma.value = val;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
