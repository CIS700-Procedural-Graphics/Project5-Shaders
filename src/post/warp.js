const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)
var x;
var y;
//document.onmousemove = function(e){
//    x = e.pageX;
//    y = e.pageY;
//}
var options = {
    amount: 0.2,
    time: 0.01   
}


var WarpShader = new EffectComposer.ShaderPass({
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
            value: window.innerWidth
        },
        u_height: {
            type: 'f',
            value: window.innerHeight
        },
        u_time: {
            type: 'f',
            value: options.time
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/warp-frag.glsl')
});

export default function Warp(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(WarpShader);  

    // set this to true on the shader for your last pass to write to the screen
    WarpShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                WarpShader.material.uniforms.u_amount.value = val;
            });
        },
        
        render: function() {;
            composer.render();
            WarpShader.material.uniforms.u_time.value += options.time;
                            //console.log(FishEyeShader.material.uniforms.u_time.value);
        }
    }
}