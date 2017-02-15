const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1
}

//NOTE: all shader pass MUST have tDiffuse (texture that it renders the frame to)
var GrayscaleShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/grayscale-frag.glsl')
});

//ALL shaders must be initialized with these arguments (renderer, scene, camera)
export default function Grayscale(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(GrayscaleShader);  

    // set this to true on the shader for your last pass to write to the screen
    GrayscaleShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                //NOTE: make sure to use .material
                GrayscaleShader.material.uniforms.u_amount.value = val;
            });
        },
        
        //NOTE: ALL post functions must have this dunctions
        render: function() {;
            composer.render();
        }
    }
}