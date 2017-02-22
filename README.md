
# Project 5: Shaders

## Project Instructions

Implement at least 75 points worth of shaders from the following list. We reserve the right to grant only partial credit for shaders that do not meet our standards, as well as extra credit for shaders that we find to be particularly impressive.

Some of these shading effects were covered in lecture -- some were not. If you wish to implement the more complex effects, you will have to perform some extra research. Of course, we encourage such academic curiosity which is why we’ve included these advanced shaders in the first place!

Document each shader you implement in your README with at least a sentence or two of explanation. Well-commented code will earn you many brownie (and probably sanity) points.

If you use shadertoy or any materials as reference, please properly credit your sources in the README and on top of the shader file. Failing to do so will result in plagiarism and will significantly reduce your points.

Examples: [https://cis700-procedural-graphics.github.io/Project5-Shaders/](https://cis700-procedural-graphics.github.io/Project5-Shaders/)

### 15 points each: Instagram-like filters


- Gaussian blur (no double counting with Bloom)
    - Description: I do two passes through the image: a horizontal then a vertical pass. I sample 9 pixels in each direction for each pixel. I also use precomputed gaussian weights.
    - GUI Controls
        - Radius of the blur
    - References:
        - https://en.wikipedia.org/wiki/Gaussian_blur
        - http://dev.theomader.com/gaussian-kernel-calculator/
        - https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5
- Bloom
    - Description: I save the original render in a separate effect composer than the one that computes the bloom. The one the computes the bloom isolates the bright moments of the scene, then does gaussian blur on that isolated texture. Then I add it to the original render.
    - GUI Controls
        - Radius of the blur
        - Amount of bloom (this is in opposite direction for some reason...)
    - References:
        - See Gaussian Blur
        - https://learnopengl.com/#!Advanced-Lighting/Bloom
- Iridescence
    - Description: Color dependent on the viewing angle. I just dotted the look with the normal of the object and then mapped that value to a color pallette
    -GUI Controls
        - None.
    - References:
        - Pallette: http://www.iquilezles.org/www/articles/palettes/palettes.htm
        - Slides: https://cis700-procedural-graphics.github.io/files/color_2_14_17.pdf
- Pointilism
    - Description: The density of the points is representative of the darkness of the area. I generate noise and if that noise is greater than the grayscale value of the pixel, then that point is black otherwise it is white.
    - GUI Controls:
        - None
    - References:
        - Slides: https://cis700-procedural-graphics.github.io/files/color_2_14_17.pdf
- Vignette
    - Description: There are two variables edge0 and edge1 that describe basically the min and max of the vignette effect. edge0 must be less than or equal to edge1 or else things break. Anyway, I essentially use the smooth step function to define where the vignette is. 
    - GUI Controls
        - edge0 (min) [0.0, 1.0]
        - edge1 (max) [0.0, 1.0]
    - References:
        - Smooth Step: http://www.shaderific.com/glsl-functions/
- Hatching
    - Description: Basically I used the sin function to create a hatching pattern and added that onto the texture. Then, I took into account the brightness of pixel; the brighter the pixel the less likely there was hatching. Then, I add some noise as well to make it less regular.
    - GUI Controls
        - Amount: size of the hatching
    - References
        - Slides: https://cis700-procedural-graphics.github.io/files/color_2_14_17.pdf
- Tone mapping: Linear 
    - Description: Adjust gamma (u_amount) which gives more luminance to the image.
    - GUI Controls:
        - Amount: Gamma Correction
    - References: 
        - https://www.shadertoy.com/view/lslGzl
        - https://en.wikipedia.org/wiki/Gamma_correction