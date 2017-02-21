const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    kx: (new THREE.Matrix3()).set(-3.0, 0.0, 3.0,
                                  -10.0, 0.0, 10.0,
                                  -3.0, 0.0, 3.0),
    ky: (new THREE.Matrix3()).set(3.0, 10.0, 3.0,
                                  0.0, 0.0, 0.0,
                                  -3.0, -10.0, -3.0)
}

var SobelShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        u_kx: {
            type: 'Matrix3fv',
            value: options.kx
        },
        u_ky: {
            type: 'Matrix3fv',
            value: options.ky
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/sobel-frag.glsl')
});

export default function Sobel(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(SobelShader);

    // set this to true on the shader for your last pass to write to the screen
    SobelShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
        },

        render: function() {;
            composer.render();
        }
    }
}
