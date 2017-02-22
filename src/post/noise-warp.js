const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    frequency: 0.5,
    time: 0
}

var NoiseWarpShader = new EffectComposer.ShaderPass({
    uniforms: {
        // this tDiffuse MUST be defined, basically going to be the texture to which it renders the frame to
        tDiffuse: {
            type: 't',
            value: null
        },
        u_freq: {
            type: 'f',
            value: options.frequency
        },
        u_time: {
            type: 'f',
            value: options.time
        },
        u_amp: {
            type: 'f',
            value: 1
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/noisewarp-frag.glsl')
});

export default function noisewarp(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the noisewarp shader
    composer.addPass(NoiseWarpShader);

    // set this to true on the shader for your last pass to write to the screen
    NoiseWarpShader.renderToScreen = true;
    var time = 1;
    var amp = 1;
    return {
        initGUI: function(gui) {
            gui.add(options, 'frequency', 0, 1).onChange(function(val) {
                NoiseWarpShader.material.uniforms.u_freq.value = val;
            });
        },
        render: function() {;
            time += 1;
            amp = Math.sin(amp) * (Math.random() * 10 + 1);
            NoiseWarpShader.material.uniforms.u_time.value = time;
            NoiseWarpShader.material.uniforms.u_amp.value = amp;
            composer.render();
        }
    }
}
