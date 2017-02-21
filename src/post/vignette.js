const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    offset: 1.0,
    darkness: 1.0
}

var VignetteShader = new EffectComposer.ShaderPass({
    uniforms: {
        // the texture the frame is rendered to before passing to the post processing shader
        tDiffuse: {
            type: 't',
            value: null
        },
        u_offset: {
            type: 'f',
            value: options.offset
        },
        u_darkness: {
            type: 'f',
            value: options.darkness
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/vignette-frag.glsl')
});

export default function Vignette(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);
    composer.addPass(new EffectComposer.RenderPass(scene, camera));
    composer.addPass(VignetteShader);  

    // set this to true on the shader for your last pass to write to the screen
    VignetteShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'offset', 0, 1).onChange(function(val) {
                VignetteShader.material.uniforms.u_offset.value = val;
            });
            gui.add(options, 'darkness', 0, 1).onChange(function(val) {
                VignetteShader.material.uniforms.u_darkness.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}