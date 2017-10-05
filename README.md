# Shaders in WebGL

# ![/assets/ShadersInWebGL_vimeoLink.png](https://vimeo.com/231613912)

## Overview

In this project, I implemented a bunch shaders and post processing effects. These were written using WebGL and javascript.
Shaders are used to give life to a 3D virtual scene by coloring pixels on the screen in a way that produces the appropriate colors and lighting. They can be used to produce special effects or create highly realistic scenes by mimicing materials found in real life.
Post-Processing effects are similar to shaders but are applied in post, so they work on a rectangular texture produced by some shader to add effects over it, think instagram filters.

# [Demo Here!](http://amansachan.com/Shaders_in_WebGL/)

## Shaders
### Lambert Shader:
The color is determined in accordance with lamberts law, ie light intensity at a point is scaled down by the angle of incidence of light at that point. The formulation becomes: finalColor = color * lightIntensity * cos(theta); where theta isthe angle between the surface normal and the inverted incoming light ray (line from that point to the light source).

### Iridescence Shader:
The color is made to be view point dependent in this shader.

### Toon Shader:
The color from lambertian shading is binned into a particular bucket to give the image a cartoony look. There can be any number of buckets but the more there are the closer the shading gets to lambertian shading.

### Pointilism Shader:
This shader takes lambertian shading and overlays noise on top of the mesh; This noise can be controlled by a threshold value.

## Post-processing
### Tone Mapping:
#### Linear Tone mapping
This tone mapping produces better blacks; There are controls for gamma and Exposure.

#### Reinhard Tone mapping
This tone mapping produces better blacks, and less saturated whites; There are controls for gamma and Exposure.

#### Filmic Tone mapping
This tone mapping is like reinhard tone mapping but produces even better blacks, and similarly less saturated whites; There are controls for gamma and Exposure.

### Vignette
Creates a vignette over the image.

### Lens Distortion mapping
Creates a lens centered at the origin, that magnifies the portion of the image behind it to the point of distortion.
