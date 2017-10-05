const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
  lensSize: 0.2
}

var lensDistortion = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_lensSize: {
            type: 'f',
            value: options.lensSize
        }
    },
    vertexShader: require('../glsl/lambert-vert.glsl'),
    fragmentShader: require('../glsl/lensDistortion-frag.glsl')
});

export default function LensDistortion(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects

    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(lensDistortion);

    // set this to true on the shader for your last pass to write to the screen
    lensDistortion.renderToScreen = true;

    return {
        initGUI: function(gui) {
          gui.add(options, 'lensSize', 0.01, 0.40).onChange(function(val) {
              lensDistortion.material.uniforms.u_lensSize.value = val;
          });
        },

        render: function() {;
            composer.render();
        }
    }
}
