const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var vignette = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        }
    },
    vertexShader: require('../glsl/lambert-vert.glsl'),
    fragmentShader: require('../glsl/vignette-frag.glsl')
});

export default function Vignette(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(vignette);

    // set this to true on the shader for your last pass to write to the screen
    vignette.renderToScreen = true;

    return {
        initGUI: function(gui) {
        },

        render: function() {;
            composer.render();
        }
    }
}
