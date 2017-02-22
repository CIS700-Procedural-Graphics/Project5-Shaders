const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var GlitchPass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        time: { type: "f", value : 0.0 },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/glitch.frag.glsl')
});

function MainPass(renderer, scene, camera) 
{
    var composer = new EffectComposer(renderer);
    composer.addPass(new EffectComposer.RenderPass(scene, camera));
    composer.addPass(GlitchPass);
    
    GlitchPass.renderToScreen = true;

    return {
        uniforms: GlitchPass.uniforms,
        render: function() {

            var width = renderer.getSize().width;
            var height = renderer.getSize().height; 
            GlitchPass.uniforms.SCREEN_SIZE.value = new THREE.Vector2( width, height);
            GlitchPass.uniforms.SCREEN_SIZE.value = new THREE.Vector2( width, height);

            composer.render();
        },
        resize: function() {
        }
    }
}

export {MainPass}