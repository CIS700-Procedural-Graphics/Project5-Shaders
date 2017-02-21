const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    radius: 1
}

var EmbossShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        radius: {
            type: 'f',
            value: options.radius
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/emboss-frag.glsl')
});

export default function Emboss(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(EmbossShader);  

    // set this to true on the shader for your last pass to write to the screen
    EmbossShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'radius', 0, 10).onChange(function(val) {
                EmbossShader.material.uniforms.radius.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}