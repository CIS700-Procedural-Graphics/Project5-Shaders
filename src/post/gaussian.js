const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    radius: 50,
    width: 100,
    height: 100
}

var GaussianShaderX = new EffectComposer.ShaderPass({
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
    fragmentShader: require('../glsl/gaussian-frag.glsl')
});

var GaussianShaderY = new EffectComposer.ShaderPass({
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
    fragmentShader: require('../glsl/gaussian-frag.glsl')
});

export default function Gaussian(renderer, scene, camera) {
    // Pass width and height of the screen to the shader
    // Not necessarily shaders
    options.width = renderer.getSize().width;
    options.height = renderer.getSize().height;
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GaussianShader
    composer.addPass(GaussianShaderX);
    composer.addPass(GaussianShaderY);    

    // set this to true on the shader for your last pass to write to the screen
    GaussianShaderY.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'radius', 0, 100).onChange(function(val) {
                GaussianShaderX.material.uniforms.u_radius.value = val;
                GaussianShaderY.material.uniforms.u_radius.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}