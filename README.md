
# Project 5: Shaders Playground


## [View the Demo Here](https://mccannd.github.io/Project5-Shaders/)

## Geometry Shaders

### Lambert

The default, the classic. Lit simply by light direction vs. normal direction

### Toon

Lambertian shading, but stratified into several levels. Normals that face away from the camera past a threshold are used for a black outline.

### Twist

Lambert fragment shading. Vertex shader is an implementation of Alan Barr's Global and Local Definitions of Solid Primitives. Vertex positions and normals will twist back and forth across the y axis on a timer.

### Matcap

Also known as spherelit or spherical environment mapping. Fakes a material or reflected environment by mapping normals facing the camera to a texture of an orthographic hemisphere. Vertex shader transforms normals to camera space and saves the camera vector. Fragment shader handles the hemisphere mapping.

New Settings:
map: switches the texture of the matcap shader

### Iridescence

Lambertian shading, but color is view dependent. Uses dot product of normal and camera vector as an input for Inigo Quilez's cosine palette. This input is shifted by the grayscale value of the unshaded surface color, so make sure to try toggling the texture and messing with the albedo color. 

### Teleport

Creates a horizontal band that makes the mesh look like it is teleporting away or back in.

Algorithm is as follows:
- Default output is lambertian shading
- Other textures for the effect are read from cylindrical mapping
- Given a y position in world space and an edge thickness, make a band / range of height in world space
- Deform the band vertically by some noise (perlin texture in this case)
- Given the band and a world space y, make some parameter t such that:
    -t is 1 if y is above the band
    -t is 0 if y is below the band
    -t smoothly interpolates from 1 to 0 inside the band
- Read a texture for the shape of the teleport edge. Apply the gradient of t by adding (2t - 1) to the grayscale / channel value
- Use that value to read an emissive color from a ramp texture
- Make transparent if t is 0
- Apply the emissive color to the lambert color

Settings:
Edge width, minimum and maximum band height, pause button

## Post-Process Shaders

### Grayscale

Hello, world!

### Vignette

Hello again, world!

Settings:
Opacity

### Warp

Shifts pixels vertically with my old perlin noise code. Very slow, not animated, replaced by the vastly superior plasma. 

Settings: 
Shift intensity

### Plasma

Calculates a -1 to 1 value using sinusoidal plasma clouds. That value both determines the intensity and angle of the UV displacement. Now we know what Mario's mushrooms are like.

Settings:
Shift intensity

### Sobel

Simple edge detection using the kernel math described on Wikipedia.

Settings:
Kernel displacement / spread

### Monitor

A flexible effect that emulates a crappy monitor or security camera footage.
White noise is Rachel's implementation. Two different time-dependent passes per fragment, then multiplied together for final noise.
A scan line periodically crosses the screen creating a horizontal distortion and darkening effect.

Settings:
vignette: darkens edges
noiseStrength: 0: no white noise, --> 1: completely white noise
bandStrength: controls how strongly the image is multiplied by the horizontal bands
bandSpeed: controls vertical scrolling speed of horizontal bands
bandWidth: controls how tall the horizontal bands are
colorize: maps grayscale value g to a green color, (g^1.3, g, g^1.2). This avoids clunky HSV conversions and preserves white and black pixels. Slider determines strength of interpolation from original to this color.
scanStrength: determines opacity and UV shift strength of the scanline. 0 turns it off.
scanWidth: controls how tall the scan line effect is
scanSpeed: controls speed of scanline scrolling.