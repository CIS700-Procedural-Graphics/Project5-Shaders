const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var options = {
//    amount: 1,
    SobelX: false,
    SobelY: false,
    Laplacian: true
}

var EdgeShader = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: {
            type: 't',
            value: null
        },
        // u_amount: {
        //     type: 'i',
        //     value: options.amount
        // },
        u_aspectx: {
            type: 'i',
            value: window.innerWidth
        },
        u_aspecty: {
            type: 'i',
            value: window.innerHeight
        },
        u_divide: {
            type: 'i',
            value: 2
        }
    },
    vertexShader: require('../glsl/pass-vert.glsl'),
    fragmentShader: require('../glsl/edge-frag.glsl')
});

export default function Grayscale(renderer, scene, camera) {

    // this is the THREE.js object for doing post-process effects
    var composer = new EffectComposer(renderer);

    // first render the scene normally and add that as the first pass
    composer.addPass(new EffectComposer.RenderPass(scene, camera));

    // then take the rendered result and apply the EdgeShader
    composer.addPass(EdgeShader);

    // set this to true on the shader for your last pass to write to the screen
    EdgeShader.renderToScreen = true;

    return {
        initGUI: function(gui) {
            var sx = gui.add(options, 'SobelX', false).listen();
            sx.onChange(function(val) {
                EdgeShader.material.uniforms.u_divide.value = 0;
                options.SobelX=true;
                options.SobelY=false;
                options.Laplacian=false;
            });
            var sy = gui.add(options, 'SobelY', false).listen();
            sy.onChange(function(val) {
                EdgeShader.material.uniforms.u_divide.value = 1;
                options.SobelX=false;
                options.SobelY=true;
                options.Laplacian=false;
            });
            var l = gui.add(options, 'Laplacian', true).listen();
            l.onChange(function(val) {
                EdgeShader.material.uniforms.u_divide.value = 2;
                options.SobelX=false;
                options.SobelY=false;
                options.Laplacian=true;
            });
        },

        render: function() {;
            composer.render();
        }
    }
}
