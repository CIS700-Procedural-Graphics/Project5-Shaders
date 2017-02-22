const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    pixellateFactor: 100.0
}

var Shader = new EffectComposer.ShaderPass({
    uniforms: {
        // the texture the frame is rendered to before passing to the post processing shader
        tDiffuse: {
            type: 't',
            value: null
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/pointilism-frag.glsl')
});

export default function Fisheye(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);
    composer.addPass(new EffectComposer.RenderPass(scene, camera));
    composer.addPass(Shader);  

    // set this to true on the shader for your last pass to write to the screen
    Shader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
             gui.add(options, 'pixellateFactor').onChange(function(val) {
                Shader.material.uniforms.pixellateFactor.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}