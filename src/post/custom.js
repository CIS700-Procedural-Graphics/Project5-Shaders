const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var start = Date.now();
var options = {
    time: start,
    rate: 5
};

export function updateTime() {
    CustomShader.material.uniforms.u_time.value = (Date.now() - start) * 0.001 * CustomShader.material.uniforms.u_rate.value;
}

var CustomShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_time: {
            type: 'f',
            value: options.time
        },
        u_rate: {
            type: 'f',
            value: options.rate
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/custom-frag.glsl')
});

export default function Custom(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the CustomShader
    composer.addPass(CustomShader);

    // set this to true on the shader for your last pass to write to the screen
    CustomShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'rate', 1, 10).onChange(function(val) {
                CustomShader.material.uniforms.u_rate.value = val;
            });
        },

        render: function() {
            composer.render();
        }
    }
}