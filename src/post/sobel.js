const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

var HorizontalPass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        tOriginal: { type: 't', value: null },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/sobel_horizontal.frag.glsl')
});

var VerticalPass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        tOriginal: { type: 't', value: null },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/sobel_vertical.frag.glsl')
});

function MainPass(renderer, scene, camera) 
{
    var width = renderer.getSize().width;
    var height = renderer.getSize().height;
    var parameters = { minFilter: THREE.LinearFilter, magFilter: THREE.LinearFilter, format: THREE.RGBAFormat, stencilBuffer: false };
    var renderTarget = new THREE.WebGLRenderTarget( width, height, parameters );

    var composer = new EffectComposer(renderer);
    composer.addPass(HorizontalPass);
    composer.addPass(VerticalPass);
    
    VerticalPass.uniforms.tOriginal.value = renderTarget;
    HorizontalPass.uniforms.tOriginal.value = renderTarget;
    VerticalPass.renderToScreen = true;

    return {
        uniforms: HorizontalPass.uniforms,
        render: function() {

            // First, we render the fullscreen image
            renderer.render(scene, camera, renderTarget, true);

            var width = renderer.getSize().width;
            var height = renderer.getSize().height; 
            HorizontalPass.uniforms.SCREEN_SIZE.value = new THREE.Vector2( width, height);
            VerticalPass.uniforms.SCREEN_SIZE.value = new THREE.Vector2( width, height);

            composer.render();
        },
        resize: function() {
        }
    }
}

export {MainPass}