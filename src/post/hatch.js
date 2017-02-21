const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)
var cameraPos;

var options = {
    amount: 1
}

var ColorfilterShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        uCameraPos: {value: cameraPos}
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/hatch-frag.glsl')
});

export default function Hatch(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(ColorfilterShader);  

    // set this to true on the shader for your last pass to write to the screen
    ColorfilterShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            // gui.add(options, 'amount', 0, 1).onChange(function(val) {
            //     ColorfilterShader.material.uniforms.u_amount.value = val;
            // });
        },
        
        render: function() {;
            composer.render();
        }
    }
}