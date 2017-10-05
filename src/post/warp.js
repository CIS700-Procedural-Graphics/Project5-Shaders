const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var warp = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        count: {
          type: 'f',
          value: 0.01
        }
    },
    vertexShader: require('../glsl/warp-vert.glsl'),
    fragmentShader: require('../glsl/warp-frag.glsl')
});

export default function WarpFilter(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(warp);

    // set this to true on the shader for your last pass to write to the screen
    warp.renderToScreen = true;

    return {
        initGUI: function(gui) {
        },

        render: function() {;
            composer.render();
        }
    }
}

function onUpdate()
{
  count++;
}
