
# Project 5: Shaders


Implementation of the following shaders:

Iridescence - Color depends on viewing angle and spans a cosine based color palette

Vignette - Simple vignette effect with a sepia filter 

Lit Sphere - Applied a material on the obj by mapping the normals to the sphere

Halftone - The uv coordinates are first offseted to the center of the screen and the fragment color at the current coordinate is determined based on a circle centered at the center of the scene, where the color of the fragment is black if the coordinates lie within the circle, otherwise its white. The radius of the circle depends on the green component of the color. The uvs and multiplied by a factor to change the number of circles.