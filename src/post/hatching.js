const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1,
    lineDensity: 400,
    lineThickness: 0.1
}

var HatchingShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { //need this for all shader passes
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        line_density: {
            type: 'f',
            value: options.lineDensity
        },
        line_thickness: {
            type: 'f',
            value: options.lineThickness
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/hatching-frag.glsl')
});

export default function Hatching(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the HatchingShader
    composer.addPass(HatchingShader);  

    // set this to true on the shader for your last pass to write to the screen
    HatchingShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                HatchingShader.material.uniforms.u_amount.value = val;
            });
             gui.add(options, 'lineDensity', 300, 1000).onChange(function(val) {
                HatchingShader.material.uniforms.line_density.value = val;
            });
             gui.add(options, 'lineThickness', 0, 1).onChange(function(val) {
                HatchingShader.material.uniforms.line_thickness.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}
