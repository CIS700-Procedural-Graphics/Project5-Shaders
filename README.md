
# Project 5: Shaders

Bloom:

My bloom shader adds a post processing pass that in one pass does one iteration of a gaussian blur (with fixed radius of 4 pixels) on the image, taking into account the color only of colors above a certain brightness threshold (which can be adjusted in the gui) and taking black for any others. The "amount" parameter in the gui adjusts the epsilon used to decide how far away to sample the texture to get surrounding color values. Thus, increasing the amount makes the image a bit more trippy. 

For this shader, I referenced https://learnopengl.com/#!Advanced-Lighting/Bloom for a brush up on Gaussian blur, some numbers for weights, as well as a general overview of bloom.

Here are two images, the second has a large value for "amount".

![](./progShots/bloomLowAmount.PNG) ![](./progShots/bloomHighAmount.PNG)  

Noise Warp:

The noise warp warps the image of Mario by offsetting the texture coordinate that is sampled for a given pixel using a noise function. I added a parameter for this shader called "speed", which controls how much the time property, which is passed into the noise function, is incremented every frame. 

The following are some pictures of my warped Mario:

![](./progShots/noise1.PNG) ![](./progShots/noise2.PNG) ![](./progShots/noise3.PNG)

Sobel Edge Detection:

The sobel shader samples texture colors surrounding the given texture corrdinate and applies a convolution using a certain kernel in the horizontal and vertical directions, which are then combined to give the overall result. For this shader the "radius" parameter controls how far away the surrounding texture samples are taken from the original texture coordinate. Thus, higher radius gives thicker edges for this shader. 

I referenced https://en.wikipedia.org/wiki/Sobel_operator for kernels to use in convolution and a general overview of Sobel edge dectection.

Here are two images, the first with a lower value for "radius" and the second with a higher one.

![](./progShots/sobelLowRadius.PNG) ![](./progShots/sobelHighRadius.PNG)  

Emboss:

This shader was basically done in the same way as Sobel, but with a different kernel. Again I had a "radius" parameter to control how far texture samples were taken from the original texture coordinate.

I used http://setosa.io/ev/image-kernels/ to find a kernel to use for convolution for this shader.

Here are two images, the first with a lower value for "radius" and the second with a higher one.

![](./progShots/embossLowRadius.PNG) ![](./progShots/embossHighRadius.PNG)  

Pointillism:

For this shader, I basically computed a probability that a pixel would be colored based on the darkness of its color, found a random value using a noise function, and using that decided whether or not I would color the pixel. I added a parameter in the GUI called "blackWhite", which when 1 makes the pixels which are colored appear black, whereas when it's 0 the pixels which are colored are their own color. I have another parameter called "darkness" that is multiplied by the probability that I compute for the pixel being colored, so that high darkness causes more pixels to be colored and lower darkness causes fewer to be colored.

Here are some images of black and white versus colored pointillism:

![](./progShots/pointBWLight.PNG) ![](./progShots/pointColor.PNG)

And some images of low and high darnkess, respectively:

![](./progShots/pointBWWhite.PNG) ![](./progShots/pointBWDark.PNG)

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