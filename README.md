
# Project 5: Shaders

## Project Instructions

Implement at least 75 points worth of shaders from the following list. We reserve the right to grant only partial credit for shaders that do not meet our standards, as well as extra credit for shaders that we find to be particularly impressive.

Some of these shading effects were covered in lecture -- some were not. If you wish to implement the more complex effects, you will have to perform some extra research. Of course, we encourage such academic curiosity which is why we’ve included these advanced shaders in the first place!

Document each shader you implement in your README with at least a sentence or two of explanation. Well-commented code will earn you many brownie (and probably sanity) points.

If you use shadertoy or any materials as reference, please properly credit your sources in the README and on top of the shader file. Failing to do so will result in plagiarism and will significantly reduce your points.

Examples: [https://cis700-procedural-graphics.github.io/Project5-Shaders/](https://cis700-procedural-graphics.github.io/Project5-Shaders/)

### 15 points each: Instagram-like filters

- Tone mapping:
    - Linear (+5 points)
    - Reinhard (+5 points)
    - Filmic (+5 points)
- Gaussian blur (no double counting with Bloom)
- Iridescence
- Pointilism
- Vignette
- Fish-eye bulge

### 25 points each: 
- Bloom
- Noise Warp
- Hatching
- Lit Sphere ([paper](http://www.ppsloan.org/publications/LitSphere.pdf))

### 37.5 points each:
- K-means color compression (unless you are extremely clever, the k-means clusterer has to be CPU side)
- Dithering
- Edge detection with Sobel filtering
- Uncharted 2 customizable filmic curve, following John Hable’s presetantion. 
    - Without Linear, Reinhard, filmic (+10 points)
    - With all of linear, Reinhard, filmic (+10 points)
    - Customizable via GUI (+17.5 points)
    - Controlling Exposure (4 points)
    - Side by side comparison between linear, Reinhard, filmic, and Uncharted2 (13.5 points). 

### 5 points - Interactivity
Implement a dropdown GUI to select different shader effects from your list.

### ??? points
Propose your own shading effects!

### For the overachievers:
Weave all your shading effects into one aesthetically-coherent scene, perhaps by incorporating some of your previous assignments!


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

## Deploy

1. Create a `gh-pages` branch on GitHub
2. Do `npm run build`
3. Commit and add all your changes.
4. Do `npm run deploy`