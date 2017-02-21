const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

let options = {
    intensity: 5,
    color: '#000000',
    radius: 5
};

let OilShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_intensity: {
            type: 'f',
            value: options.intensity
        },
        u_radius: {
          type: 'v3',
          value: options.radius
        },
        u_scale: {
          type: 'v3',
          value: new THREE.Vector2(1.0 / window.innerWidth, 1.0 / window.innerHeight)
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/oil-frag.glsl')
});


export default function Oil(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    let composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the OilShader
    composer.addPass(OilShader);

    // set this to true on the shader for your last pass to write to the screen
    OilShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            gui.add(options, 'intensity', 0, 50).onChange(function(val) {
              OilShader.material.uniforms.u_intensity.value = val;
            });
            gui.add(options, 'radius', 0, 10).step(1).onChange(function(val) {
              OilShader.material.uniforms.u_radius.value = val;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
