# Shaders

### Lambert
Standard lambert shading by default!

### Toon
In this Toon shader, we band color intensities together and set them to a floored value. We also take the vertex normal and color the fragment by the view direction if it exceeds a certain angle. This allows for a fun rainbowy outline of a character who seems to be shaded by a few colors only.

### Lit Sphere
In this shader, we load MatCap spheres that were pre-generated. We then map the normal-space to UV-space using one easy trick that pipeline engineers don't want you to know! We extract the color from that texture using the corresponding UVs (mapped from normals) and set the vertex color. The end result is really cool materials that are applied to our model. This could have also been done as a fragment shader but I think it's a bit easier as a vertex shader and works well enough for our mesh which has high vertex density.

# Post Processes

### Grayscale
This is our Hello World, and is just a standard RGB -> Luminosity map.

### Tint
We add a flat color to our fragment shaded values.

### Sobel
We take the two gradient Sobel kernels and apply a high pass to the image. We threshold the intensity values of both horizontal and vertical gradients and set the fragment colors to black beyond a certain point to highlight edges.

### Bloom
The pipeline is as follows: High pass, Blur, Additive Re-blending. The first step is a multi-target pass that generates a texture of only high intensity fragments and a texture of regular scene rendering. We then blur the high pass scene with a gaussian blur. The end result is additively recombined with the original. This yields a bloom effect.


### Oil/Watercolor paintings
For each pixel, we band intensities but this time we keep track of the sum of the R, G, and B values of that intensity as well as how often an intensity appears (the mode). We take the most frequent intensity band and then do a reverse lookup of the total R, G, and B values of that intensity band. We then divide by the mode of the intensity to obtain a flat color that we apply to pixels. Because the mode intensity doesn't change that often over pixels, we get the blotchiness that is characteristic of oil/watercolor paintings.

### Dithering
Since the traditional serial Dithering algorithms aren't parallelizable in glsl, we resort to using other approximation methods. In particular, we perform Ordered Dithering using a generated Bayer matrix to "push" error around. We add the error to the pixel and round to either 1 or 0 (full color or none at all). The end result is pretty neat.
