const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1,
    h1: { fx: 150,
    	  fy: 150,
    	  scale: 1.0,
    	  noise: 1.5,
    	},
    h2: { fx: 150,
    	  fy: 150,
    	  scale: 1.0,
    	  noise: 0.3,
    	},
}

var GrayscaleShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
        u_h1fx: {
            type: 'f',
            value: options.h1.fx
        },
        u_h1fy: {
            type: 'f',
            value: options.h1.fy
        },
        u_h1scale: {
            type: 'f',
            value: options.h1.scale
        },
        u_h1noise: {
            type: 'f',
            value: options.h1.noise
        },
        u_h2fx: {
            type: 'f',
            value: options.h2.fx
        },
        u_h2fy: {
            type: 'f',
            value: options.h2.fy
        },
        u_h2scale: {
            type: 'f',
            value: options.h2.scale
        },
        u_h2noise: {
            type: 'f',
            value: options.h2.noise
        },
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/hatching-frag.glsl')
});

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
                GrayscaleShader.material.uniforms.u_amount.value = val;
            });
            //hatch 1
            gui.add(options.h1, 'fx', 10,300).step(2).name("hatch 1 freq x").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h1fx.value = val;
            });
            gui.add(options.h1, 'fy', 10,300).step(2).name("hatch 1 freq y").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h1fy.value = val;
            });
            gui.add(options.h1, 'scale', 0.01,1.0).step(.1).name("hatch 1 scale").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h1scale.value = val;
            });
            gui.add(options.h1, 'noise', 0.0,2.0).step(.1).name("hatch 1 noise").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h1noise.value = val;
            });
            //hatch 2
            gui.add(options.h2, 'fx', 10,300).step(2).name("hatch 2 freq x").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h2fx.value = val;
            });
            gui.add(options.h2, 'fy', 10,300).step(2).name("hatch 2 freq y").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h2fy.value = val;
            });
            gui.add(options.h2, 'scale', 0.01,1.0).step(.1).name("hatch 2 scale").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h2scale.value = val;
            });
            gui.add(options.h2, 'noise', 0.0,2.0).step(.1).name("hatch 2 noise").onChange( function(val) {
            	GrayscaleShader.material.uniforms.u_h2noise.value = val;
            });
        },

        
        render: function() {;
            composer.render();
        }
    }
}