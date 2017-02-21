const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    amount: 0.5,
    radius: 50,
    width: 100,
    height: 100
}

var BrightnessFilterPass = new EffectComposer.ShaderPass({
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
    fragmentShader: require('../glsl/brightnessfilter-frag.glsl')
});

var BloomShaderX = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_radius: {
            type: 'f',
            value: options.radius
        },
        u_width: {
            type: 'f',
            value: options.width
        },
        u_height: {
            type: 'f',
            value: options.height
        },
        u_dir: {
            type: 'v2',
            value: new THREE.Vector2(1.0, 0.0)
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-frag.glsl')
});

var BloomShaderY = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_radius: {
            type: 'f',
            value: options.radius
        },
        u_width: {
            type: 'f',
            value: options.width
        },
        u_height: {
            type: 'f',
            value: options.height
        },
        u_dir: {
            type: 'v2',
            value: new THREE.Vector2(0.0, 1.0)
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/bloom-frag.glsl')
});

export default function Bloom(renderer, scene, camera) {
    // Pass width and height of the screen to the shader
    // Not necessarily shaders
    options.width = renderer.getSize().width;
    options.height = renderer.getSize().height;
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the BloomShader
    // composer.addPass(BloomShaderX);
    // composer.addPass(BloomShaderY);    

    composer.addPass(BrightnessFilterPass);

    // set this to true on the shader for your last pass to write to the screen
    BrightnessFilterPass.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'radius', 0, 100).onChange(function(val) {
                BloomShaderX.material.uniforms.u_radius.value = val;
                BloomShaderY.material.uniforms.u_radius.value = val;
            });

            gui.add(options, 'amount', 0, 1).onChange(function(val) {
                BrightnessFilterPass.material.uniforms.u_amount.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}