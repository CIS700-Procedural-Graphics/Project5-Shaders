const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 0,
    threshold: 0.7
}

//NOTE: all shader pass MUST have tDiffuse (texture that it renders the frame to)
var ExtractShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_threshold: {
            type: 'f',
            value: options.threshold
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-extract-frag.glsl')
});

var GaussianShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        window_width: {
            type: 'f',
            value: window.innerWidth
        },
        window_height: {
            type: 'f',
            value: window.innerHeight
        }

    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-gaussian-frag.glsl')
});

var MergeShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        tOriginal: {
            type: 't',
            value: null
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-merge-frag.glsl')
});

//ALL shaders must be initialized with these arguments (renderer, scene, camera)
export default function Bloom(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);
    var composer2 = new EffectComposer(renderer);
   
    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera, null, new THREE.Color(0x000000, 0)));
    composer.addPass(ExtractShader);
    composer.addPass(GaussianShader);
    
    composer2.addPass(new EffectComposer.RenderPass(scene, camera));
    MergeShader.material.uniforms.tOriginal.value = composer2.readBuffer.texture;
    composer.addPass(MergeShader);

    // set this to true on the shader for your last pass to write to the screen
    MergeShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'threshold', 0, 1, 0.05).onChange(function(val) {
                //NOTE: make sure to use .material
                ExtractShader.material.uniforms.u_threshold.value = val;
            });
            gui.add(options, 'amount', 0, 5, 1).onChange(function(val) {
                //NOTE: make sure to use .material
                GaussianShader.material.uniforms.u_amount.value = val;
            });
        },
        
        //NOTE: ALL post functions must have this dunctions
        render: function() {
            composer.render();
            composer2.render();
        }
    }
}