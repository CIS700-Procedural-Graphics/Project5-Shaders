
# Project 5: Shaders

## Shaders
1. Toon
    - To get toon shading, we bin the colors based on the look vector.
2. Iridescence
    - Somewhat similar to Toon shader. Instead of binning, we just map the color to a custom Color Palette and pick colors from it based on the angle between the normal and the look vector.
    - You can change almost all the parameters in the GUI to get the colors of your choice.
    - Color Palettes: http://dev.thi.ng/gradients/
3. Pointilism
    - Use the `Intensity` as a probability to randomly draw (or not draw) the point.
    - I have used a pseudo random number generator that takes in position of the point to generate a random number.

## Post Shaders
1. Sepia
    - Standard sepia filter.
2. Negative
    - `1 - Color`
2. Gaussian blur
    - Tried creating a kernel with variable inputs. But does not work for some reason.
    - So, for now, I am using a 5*5 hardcoded kernel for convolution.
3. Unsharp Masking (sharpening)    
    - Apply Gaussian blur
    - Subtract the blurred image from the original image to get the details
    - Add the details according to some weight
    - i.e. `original + (original - blurred) * weight`
4. Spiral Warping
    - The method is pretty much straight forward as shown [here](http://www.geeks3d.com/20110428/shader-library-swirl-post-processing-filter-in-glsl/).
    - Although I don't understand completely understand how the dot product of dot product thing shown there works.
5. Averaging
    - Average the values in the neighborhood to achieve blurring.
    - Changing the *amount* in the GUI changes the kernel size in the shader to achieve more or less blurring.
6. Edge Detection
    - Sobel - horizontal edges
        - Detects horizontal edges only
    - Sobel - vertical edges
        - Detects vertical edges only
    - Laplacian edge detection
        - Detects edges in all the directions

## References
1. Gaussian Blur:
    - https://en.wikipedia.org/wiki/Gaussian_blur
    - http://homepages.inf.ed.ac.uk/rbf/HIPR2/gsmooth.htm
2. Laplacian Edge Detection:
    - https://en.wikipedia.org/wiki/Discrete_Laplace_operator
3. Sobel Edge Detection:
    - https://en.wikipedia.org/wiki/Sobel_operator
4. Color Palette using cosine:
    - http://dev.thi.ng/gradients/
5. Spiral Warp tutorial:
    - http://www.geeks3d.com/20110428/shader-library-swirl-post-processing-filter-in-glsl/
