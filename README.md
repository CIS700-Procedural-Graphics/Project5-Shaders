
# Project 5: Shaders

## Getting Started

### main.js

`main.js` is responsible for setting up the scene with the Mario mesh, initializing GUI and camera, etc.

### Adding Shaders

To add a shader, you'll want to add a file to the `src/shaders` or `src/post` folder. As examples, we've provided two shaders `lambert.js` and `grayscale.js`. Here, I will give a brief overview of how these work and how everything hooks together.

**shaders/lambert.js**

IMPORTANT: I make my lambert shader available by exporting it in `shaders/index.js`. 

```javascript
export {default as Lambert} from './Lambert'
```

Each shader should export a function that takes in the `renderer`, `scene`, and `camera`. That function should return a `Shader` Object.

`Shader.initGUI` is a function that will be called to initialize the GUI for that shader. in `lambert.js`, you can see that it's here that I set up all the parameters that will affect my shader.

`Shader.material` should be a `THREE.ShaderMaterial`. This should be pretty similar to what you've seen in previous projects. `Shader.material.vertexShader` and `Shader.material.fragmentShader` are the vertex and fragment shaders used.

At the bottom, I have the following snippet of code. All it does is bind the Mario texture once it's loaded.

```javascript
textureLoaded.then(function(texture) {
    Shader.material.uniforms.texture.value = texture;
});
```

So when you change the Shader parameter in the GUI, `Shader.initGUI(gui)` will be called to initialize the GUI, and then the Mario mesh will have `Shader.material` applied to it.

**post/grayscale.js**

GUI parameters here are initialized the same way they are for the other shaders.

Post process shaders should use the THREE.js `EffectComposer`. To set up the grayscale filter, I first create a new composer: `var composer = new EffectComposer(renderer);`. Then I add a a render pass as the first pass: `composer.addPass(new EffectComposer.RenderPass(scene, camera));`. This will set up the composer to render the scene as normal into a buffer. I add my filter to operate on that buffer: `composer.addPass(GrayscaleShader);`, and mark it as the final pass that will write to the screen `GrayscaleShader.renderToScreen = true;`

GrayscaleShader is a `EffectComposer.ShaderPass` which basically takes the same arguments as `THREE.ShaderMaterial`. Note, that one uniform that will have to include is `tDiffuse`. This is the texture sampler which the EffectComposer will automatically bind the previously rendered pass to. If you look at `glsl/grayscale-frag.glsl`, this is the texture we read from to get the previous pixel color: `vec4 col = texture2D(tDiffuse, f_uv);`.

IMPORTANT: You initially define your shader passes like so:

```javascript
var GrayscaleShader = new EffectComposer.ShaderPass({
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
    fragmentShader: require('../glsl/grayscale-frag.glsl')
});
```

BUT, if you want to modify the uniforms, you need to do so like so: `GrayscaleShader.material.uniforms.u_amount.value = val;`. Note the extra `.material` property.