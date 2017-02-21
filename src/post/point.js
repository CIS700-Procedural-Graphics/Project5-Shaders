const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

let options = {
    threshold: 0.35,
};

let PointShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_threshold: {
            type: 'f',
            value: options.threshold
        },
        u_scale: {
          type: 'v3',
          value: new THREE.Vector2(1.0 / window.innerWidth, 1.0 / window.innerHeight)
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/point-frag.glsl')
});

export default function Point(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    let composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the PointShader
    composer.addPass(PointShader);

    // set this to true on the shader for your last pass to write to the screen
    PointShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'threshold', 0, 1).onChange(function(val) {
                PointShader.material.uniforms.u_threshold.value = val;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
