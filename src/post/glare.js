const THREE = require('three');
const EffectComposer = require('three-effectcomposer')(THREE)

// This pass thresholds, but also downsamples the original render (no need to rerender)
var ThresholdDownsamplePass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        tOriginal: { type: 't', value: null },
        tDownsampled: { type: 't', value: null },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/glare_threshold_downsample.frag.glsl')
});

var ThresholdPass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/glare_threshold.frag.glsl')
});

var HorizontalPass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/gaussian_horizontal.frag.glsl')
});

var VerticalPass = new EffectComposer.ShaderPass({
    uniforms: {
        tDiffuse: { type: 't', value: null },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/gaussian_vertical.frag.glsl')
});

var ComposePass = new EffectComposer.ShaderPass({
    uniforms: {
        time: { type: "f", value : 0.0 },
        tDiffuse: { type: 't', value: null },
        tOriginal: { type: 't', value: null },
        tDownsampled: { type: 't', value: null },
        averageFactor: { type: "f", value : 0.5 },
        finalFactor: { type: "f", value : 0.0 },
        SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) }
    },
    vertexShader: require('../shaders/post/pass.vert.glsl'),
    fragmentShader: require('../shaders/post/glare_compose.frag.glsl')
});

function GlarePass(renderer, scene, camera) 
{
    var width = renderer.getSize().width;
    var height = renderer.getSize().height;

    var parameters = { minFilter: THREE.LinearFilter, magFilter: THREE.LinearFilter, format: THREE.RGBAFormat, stencilBuffer: false };

    var renderTarget = new THREE.WebGLRenderTarget( width, height, parameters );
    var renderTargetX2 = new THREE.WebGLRenderTarget( width / 2, height / 2, parameters );
    var renderTargetX4 = new THREE.WebGLRenderTarget( width / 4, height / 4, parameters );
    var renderTargetX8 = new THREE.WebGLRenderTarget( width / 8, height / 8, parameters );
    var renderTargetX16 = new THREE.WebGLRenderTarget( width / 16, height / 16, parameters );

    var composers = [];
    var blurIterations = 4;

    for(var i = 0; i < 3; i++)
    {
        var scaleFactor = Math.pow(2, i + 1);
        var scale = 1.0 / scaleFactor;

        var downsampledRenderTarget = new THREE.WebGLRenderTarget( width * scale, height * scale, parameters );

        var composer = new EffectComposer(renderer, downsampledRenderTarget);
        composer.addPass(ThresholdDownsamplePass);

        // Iterations
        for(var j = 0; j < blurIterations; j++)
        {
            composer.addPass(HorizontalPass);
            composer.addPass(VerticalPass);
        }

        composer.addPass(ComposePass);
        composers.push(composer);
    }

    // set this to true on the shader for your last pass to write to the screen
    ComposePass.uniforms.tOriginal.value = renderTarget;
    ThresholdDownsamplePass.uniforms.tOriginal.value = renderTarget;

    return {
        uniforms: HorizontalPass.uniforms,
        render: function() {
            
            // First, we render the fullscreen image
            renderer.render(scene, camera, renderTarget, true);

            var previousRT = null;

            for(var i = 2; i >= 0; i--)
            {
                var scaleFactor = Math.pow(2, i + 1);
                var scale = 1.0 / scaleFactor;

                ComposePass.uniforms.tDownsampled.value = previousRT;                
                ComposePass.uniforms.averageFactor.value = (previousRT == null ? 1.0 : .5);
                ComposePass.renderToScreen = (i == 0);
                ComposePass.uniforms.finalFactor.value = (i == 0);
                
                HorizontalPass.uniforms.SCREEN_SIZE.value = new THREE.Vector2( width * scale, height * scale);
                VerticalPass.uniforms.SCREEN_SIZE.value = new THREE.Vector2( width * scale, height * scale);

                composers[i].render();

                previousRT = composers[i].writeBuffer;
            }

        },
        resize: function() {
        }
    }
}

export {GlarePass}