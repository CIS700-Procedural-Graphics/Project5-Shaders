const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    vignette: 1,
    noiseStrength: 0.3,
    bandStrength: 0.1,
    bandSpeed: 1.0,
    bandWidth: 0.0,
    colorize: 1.0,
    scanStrength: 1.0,
    scanSpeed: 1.0,
    scanWidth: 1.0

}

var clock = new THREE.Clock();
var t = 0.0;

var MonitorShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        u_vignette: {
            type: 'f',
            value: options.vignette
        },
        time : {
            type: 'f',
            value: t
        },
        u_bandStrength : {
            type: 'f',
            value: options.bandStrength
        },
        u_bandSpeed : {
            type: 'f',
            value: options.bandSpeed
        },
        u_bandWidth : {
            type: 'f',
            value: options.bandWidth
        },
        u_noiseStrength : {
            type: 'f',
            value: options.noiseStrength
        },
        u_colorize : {
            type: 'f',
            value: options.colorize
        },
        u_scanStrength : {
            type: 'f',
            value: options.scanStrength
        },
        u_scanWidth : {
            type: 'f',
            value: options.scanWidth
        },
        u_scanSpeed : {
            type: 'f',
            value: options.scanSpeed
        }


    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/noisy_display.glsl')
});

export default function Monitor(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(MonitorShader);  

    // set this to true on the shader for your last pass to write to the screen
    MonitorShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'vignette', 0, 1).onChange(function(val) {
                MonitorShader.material.uniforms.u_vignette.value = val;
            });
            gui.add(options, 'noiseStrength', 0, 1).onChange(function(val) {
                MonitorShader.material.uniforms.u_noiseStrength.value = val;
            });
            gui.add(options, 'bandStrength', 0, 1).onChange(function(val) {
                MonitorShader.material.uniforms.u_bandStrength.value = val;
            });
            gui.add(options, 'bandSpeed', 0, 50).onChange(function(val) {
                MonitorShader.material.uniforms.u_bandSpeed.value = val;
            });
            gui.add(options, 'bandWidth', 0, 1).onChange(function(val) {
                MonitorShader.material.uniforms.u_bandWidth.value = val;
            });
            gui.add(options, 'colorize', 0, 1).onChange(function(val) {
                MonitorShader.material.uniforms.u_colorize.value = val;
            });
            gui.add(options, 'scanStrength', 0, 2).onChange(function(val) {
                MonitorShader.material.uniforms.u_scanStrength.value = val;
            });
            gui.add(options, 'scanWidth', 0, 2).onChange(function(val) {
                MonitorShader.material.uniforms.u_scanWidth.value = val;
            });
            gui.add(options, 'scanSpeed', 0, 10).onChange(function(val) {
                MonitorShader.material.uniforms.u_scanSpeed.value = val;
            });

        },
        
        render: function() {;
            composer.render();
        },

        update: function() {
            t += clock.getDelta();
            MonitorShader.material.uniforms.time.value = t;
        }
    }
}