const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 0.2
}

var clock = new THREE.Clock();
var t = 0.0;

var PlasmaShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },

        time : {
            type: 'f',
            value: t
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/plasma_frag.glsl')
});

export default function Plasma(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(PlasmaShader);  

    // set this to true on the shader for your last pass to write to the screen
    PlasmaShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                PlasmaShader.material.uniforms.u_amount.value = val;
            });
        },
        
        render: function() {;
            composer.render();
            
        },

        update: function() {
            t += clock.getDelta();
            PlasmaShader.material.uniforms.time.value = t;
        }
    }
}