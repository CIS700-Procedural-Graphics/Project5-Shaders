const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    iterationsX: 10,
    iterationsY: 10,
    threshold: 1,
    pixels: 1
}

var HighPassShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        threshold: {
            type: 'f',
            value: options.threshold
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/highpass-frag.glsl')
});

var GaussianXShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        resolution: {
            type: 'f',
            value: null
        },
        pixels: {
            type: 'f',
            value: options.pixels
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/gaussianX-frag.glsl')
});

var GaussianYShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        resolution: {
            type: 'f',
            value: null
        },
        pixels: {
            type: 'f',
            value: options.pixels
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/gaussianY-frag.glsl')
});

var AddShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        tOther: {
            type: 't',
            value: null
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/add-frag.glsl')
});

var composer;
var composer2;

function draw(renderer, scene, camera) {
    // this is the THREE.js object for doing post-process effects
    composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    var renderpass = new EffectComposer.RenderPass(scene, camera);
    renderpass.clearColor = new THREE.Color(0x000000);
    composer.addPass(renderpass);
    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(HighPassShader);
    for (var i = 0; i < options.iterationsX; i ++) {
        composer.addPass(GaussianXShader);
    }

    for (var i = 0; i < options.iterationsY; i ++) {
        composer.addPass(GaussianYShader);
    }

    AddShader.material.uniforms.tOther.value = composer.readBuffer.texture;

    composer2 = new EffectComposer(renderer);
    composer2.addPass(new EffectComposer.RenderPass(scene, camera));
    composer2.addPass(AddShader);

    // set this to true on the shader for your last pass to write to the screen
    AddShader.renderToScreen = true; 
}

export default function Bloom(renderer, scene, camera) {
    
    draw(renderer,scene,camera);

    return {
        initGUI: function(gui) {
            gui.add(options, 'iterationsX', 1,30).step(1).onChange(function(val) {
                draw(renderer,scene,camera);
            });
            gui.add(options, 'iterationsY', 1,30).step(1).onChange(function(val) {
                draw(renderer,scene,camera);
            });
            gui.add(options, 'threshold', 0,3).onChange(function(val) {
                HighPassShader.material.uniforms.threshold.value = val;
            });
            gui.add(options, 'pixels', 1,20).step(1).onChange(function(val) {
                GaussianXShader.material.uniforms.pixels.value = val;
                GaussianYShader.material.uniforms.pixels.value = val;
            });
        },
        
        render: function() {
            GaussianXShader.material.uniforms.resolution.value = renderer.getSize().width;
            GaussianYShader.material.uniforms.resolution.value = renderer.getSize().height;
            composer.render();
            composer2.render();
        }
    }
}