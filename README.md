# [HW4: Shape Grammar](https://github.com/CIS700-Procedural-Graphics/Project4-Shape Grammar)

## Project Description

A bunch of shaders and post processing effects

### Iridescence Shader:

color is view point dependent shader;

### Toon Shader:

color is approximated to the nearest bucket;

### Pointilism Shader:

Overlay noise on top of the mesh; can control the threshold

<<<<<<< HEAD
### Tone Mapping:

#### Linear Tone mapping

Better blacks; can control gamma and Exposure
=======
- Tone mapping:
    - Linear (5 points)
    - Reinhard (5 points)
    - Filmic (5 points)
- Gaussian blur (no double counting with Bloom)
- Iridescence
- Pointilism
- Vignette
- Fish-eye bulge

### 25 points each: 
- Bloom
- Noise Warp
- Hatching
- Edge detection with Sobel filtering
- Lit Sphere ([paper](http://www.ppsloan.org/publications/LitSphere.pdf))
- Uncharted 2 customizable filmic curve, following John Hable’s presetantion. 
    - Without Linear, Reinhard, filmic (10 points)
    - With all of linear, Reinhard, filmic (10 points)
    - Customizable via GUI: (5 points total)
        - Controlling Exposure 
        - Side by side comparison between linear, Reinhard, filmic, and Uncharted2 .

### 37.5 points each:
- K-means color compression (unless you are extremely clever, the k-means clusterer has to be CPU side)
- Dithering
 
>>>>>>> origin/master

#### Reinhard Tone mapping

Better blacks, less saturated whites; can control gamma and Exposure

#### Filmic Tone mapping

Like reinhard but even better blacks, similarly less saturated whites; can control gamma and Exposure

#### Vignette

creates a vignette as a post process effect

#### Lens Distortion mapping

creates a lens centered at the origin, that magnifies the stuff behind it to the point of distortion.
