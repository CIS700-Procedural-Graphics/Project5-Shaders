const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    edge0: 0.2,
    width: 100,
    height: 100,
    edge1: 0.8
}

var VignetteShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        u_width: {
            type: 'f',
            value: options.width
        },
        u_height: {
            type: 'f',
            value: options.height
        },
        u_edge0: {
            type: 'f',
            value: options.edge0
        },
        u_edge1: { 
            type: 'f',
            value: options.edge1
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/vignette-frag.glsl')
});

export default function Vignette(renderer, scene, camera) {
    // Pass width and height of the screen to the shader
    // Not necessarily shaders
    options.width = renderer.getSize().width;
    options.height = renderer.getSize().height;
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the VignetteShader
    composer.addPass(VignetteShader);  

    // set this to true on the shader for your last pass to write to the screen
    VignetteShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'edge0', 0, 1).onChange(function(val) {
                VignetteShader.material.uniforms.u_edge0.value = val;
            });

            gui.add(options, 'edge1', 0, 1).onChange(function(val) {
                VignetteShader.material.uniforms.u_edge1.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}