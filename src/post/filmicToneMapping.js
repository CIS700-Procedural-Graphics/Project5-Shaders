const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var filmictoneMapping = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/filmictone-frag.glsl')
});

export default function FilmicFilter(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(filmictoneMapping);

    // set this to true on the shader for your last pass to write to the screen
    filmictoneMapping.renderToScreen = true;

    return {
      initGUI: function(gui) {
      },
        render: function() {
            composer.render();
        }
    }
}
