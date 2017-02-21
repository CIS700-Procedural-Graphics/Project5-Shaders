const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    contrast: 1
}

var ContrastShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        contrast: {
            type: 'f',
            value: options.contrast
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/contrast-frag.glsl')
});

export default function Contrast(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(ContrastShader);  

    // set this to true on the shader for your last pass to write to the screen
    ContrastShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'contrast', 0, 1).onChange(function(val) {
                ContrastShader.material.uniforms.contrast.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}