const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
    darkness: 1.0,
    blackWhite: 1
}

var PointShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        darkness: {
            type: 'f',
            value: options.darkness
        },
        blackWhite: {
            type: 'i',
            value: options.blackWhite
        }
    },
    vertexShader: require('../glsl/point-vert.glsl'),
    fragmentShader: require('../glsl/point-frag.glsl')
});

export default function Pointillism(renderer, scene, camera) {
    
    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the GrayscaleShader
    composer.addPass(PointShader);  

    // set this to true on the shader for your last pass to write to the screen
    PointShader.renderToScreen = true;  

    return {
        initGUI: function(gui) {
            gui.add(options, 'darkness', 0.5, 1.5).onChange(function(val) {
                PointShader.material.uniforms.darkness.value = val;
            });
            gui.add(options, 'blackWhite', 0, 1).step(1).onChange(function(val) {
                PointShader.material.uniforms.blackWhite.value = val;
            });
        },
        
        render: function() {;
            composer.render();
        }
    }
}