const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

let options = {
    threshold: 0.9,
    color: '#000000',
    std: 5
};

let bufferTexture = THREE.WebGLRenderTarget(window.innerWidth, window.innerHeight);

let HighPass = new EffectComposer.ShaderPass({
  uniforms: {
      tDiffuse: {
          type: 't',
          value: null
      },
      u_threshold: {
          type: 'f',
          value: options.threshold
      }
  },
  vertexShader: require('../glsl/pass-vert.glsl'),
  fragmentShader: require('../glsl/high-frag.glsl')
});

let BlurPass = new EffectComposer.ShaderPass({
  uniforms: {
      tDiffuse: {
          type: 't',
          value: null
      },
      u_std: {
        type: 'v3',
        value: options.std
      },
      u_scale: {
        type: 'v3',
        value: new THREE.Vector2(1.0 / window.innerWidth, 1.0 / window.innerHeight)
      }
  },
  vertexShader: require('../glsl/pass-vert.glsl'),
  fragmentShader: require('../glsl/blur-frag.glsl')
});

let BloomShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        tBuffer: {
          type: 't',
          value: null
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-frag.glsl')
});


export default function Bloom(renderer, scene, camera) {

    renderer.render(scene, camera, bufferTexture);

    let composer = new EffectComposer(renderer);
    composer.addPass(new EffectComposer.RenderPass(scene, camera));
    composer.addPass(HighPass);
    composer.addPass(BlurPass);
    composer.addPass(BlurPass);
    composer.addPass(BlurPass);

    let final = new EffectComposer(renderer);
    final.addPass(new EffectComposer.RenderPass(scene, camera));
    final.addPass(BloomShader);
    BloomShader.material.uniforms.tBuffer.value = composer.renderTarget2.texture;

    BloomShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'threshold', 0, 1).onChange(function(val) {
              HighPass.material.uniforms.u_threshold.value = val;
            });
            gui.add(options, 'std', 0.01, 10).onChange(function(val) {
              BlurPass.material.uniforms.u_std.value = val;
            });
        },

        render: function() {
            composer.render();
            final.render();
        }
    }
}
