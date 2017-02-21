const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    persistence: 0.5,
    speed: 0.1,
    time: 50.0
}

var NoiseShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        perst: {
            type: 'f',
            value: options.persistence
        },
        time: {
            type: 'f',
            value: options.time
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/noiseWarp-frag.glsl')
});

export default function Noise(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(NoiseShader);  

    // set this to true on the shader for your last pass to write to the screen
    NoiseShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'speed', 0, 0.5).onChange(function(val) {
                options.speed = val;
            });
        },
        
        render: function() {;
            options.time+=options.speed;
            NoiseShader.material.uniforms.time.value = options.time;
            composer.render();
        }
    }
}