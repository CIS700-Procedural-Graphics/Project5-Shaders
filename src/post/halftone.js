const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 1,
	noise: 1,
	color: 1
}

var HalfToneShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_amount: {
            type: 'f',
            value: options.amount
        },
		noise_amount: {
            type: 'f',
            value: 1.0
        },
		color_amount: {
            type: 'f',
            value: 1.0
        },
		aspect_ratio: {
			type: 'f',
			value: 1.0
		}
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/halftone-frag.glsl')
});

export default function Halftone(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(HalfToneShader);
	
	HalfToneShader.uniforms.aspect_ratio.value = camera.aspect;

    // set this to true on the shader for your last pass to write to the screen
    HalfToneShader.renderToScreen = true;  
    return {
        initGUI: function(gui) {
            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                HalfToneShader.material.uniforms.u_amount.value = val;
            });
			gui.add(options, 'noise', 0, 10).onChange(function(val) {
                HalfToneShader.material.uniforms.noise_amount.value = val;
            });
			gui.add(options, 'color', 0, 1).onChange(function(val) {
                HalfToneShader.material.uniforms.color_amount.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}