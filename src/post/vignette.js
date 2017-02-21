const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1,
    color: '#ffffff'
}

var VignetteShaders = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        }, 
        u_color: {
            type: 'v3',
            value: new THREE.Color(options.lightColor)
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/vignette-frag.glsl')
});

export default function Vignette(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the VignetteShaders
    composer.addPass(VignetteShaders);  

    // set this to true on the shader for your last pass to write to the screen
    VignetteShaders.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                VignetteShaders.material.uniforms.u_amount.value = val;
            });
            gui.addColor(options, 'color').onChange(function(val) {
                VignetteShaders.material.uniforms.u_color.value = new THREE.Color(val);
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}