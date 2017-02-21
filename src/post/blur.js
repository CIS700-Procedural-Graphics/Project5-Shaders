const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 0.00077,
    iterations: 5,
    coeffs: [1.0,  4.0,  7.0,  4.0, 1.0,
             4.0, 16.0, 26.0, 16.0, 4.0,
             7.0, 26.0, 41.0, 26.0, 7.0,
             4.0, 16.0, 26.0, 16.0, 4.0,
             1.0,  4.0,  7.0,  4.0, 1.0]
}

export default function Blur(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    var passes = [];

    var getNewBlurPass = function() {
      var blurPass = new EffectComposer.ShaderPass({
          uniforms: {
              tDiffuse: {
                  type: 't',
                  value: null
              },
              u_amount: {
                  type: 'f',
                  value: options.amount
              },
              u_iterations :{
                  type: 'i',
                  value: options.iterations
              },
              u_coeffs: {
                  type: 'fv1',
                  value: options.coeffs
              }
          },
          vertexShader: require('../glsl/pass-vert.glsl'),
          fragmentShader: require('../glsl/blur-frag.glsl')
      });
      passes.push(blurPass);
      return blurPass;
    };

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    var displayPass  = getNewBlurPass();
    composer.addPass(displayPass);

    // set this to true on the shader for your last pass to write to the screen
    displayPass.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 0.005).onChange(function(val) {
                passes.forEach(function(pass) {
                  pass.material.uniforms.u_amount.value = val;
                });
            });
            gui.add(options, 'iterations', 0, 10).onChange(function(val) {

              composer = new EffectComposer(renderer);
              passes = [];
              // first render the scene normally and add that as the first pass
              composer.addPass(new EffectComposer.RenderPass(scene, camera));

              // then take the rendered result and apply the GrayscaleShader
              for (var i = 0; i < options.iterations; i++) {
                var blurPass = getNewBlurPass();
                composer.addPass(blurPass);
              }

              var displayPass  = getNewBlurPass();
              composer.addPass(displayPass);
              displayPass.renderToScreen = true;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
