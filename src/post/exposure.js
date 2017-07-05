const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    exposure: 1.0
}

var clock = new THREE.Clock();
var t = 0.0;

var ExposureShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_exposure: {
            type: 'f',
            value: options.exposure
        },
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/exposure_frag.glsl')
});

export default function Exposure(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(ExposureShader);  

    // set this to true on the shader for your last pass to write to the screen
    ExposureShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'exposure', 0, 10).onChange(function(val) {
                ExposureShader.material.uniforms.u_exposure.value = val;
            });
        },
        
        render: function() {;
            composer.render();
            
        },

        update: function() {
            
        }
    }
}