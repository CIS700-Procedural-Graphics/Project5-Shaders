
# Project 5: Shaders

## The Project

The Shaders I Implemented and resources if used (other than Rachel's slides)

Post-Processing Effects:</br>
[15] Iridescence</br>
    Color the rgb values based on the dot product between the normal and the camera's pov. Done through cosine weighting where the r,g,b values are represented with a cosine function but their each offset differently so that when we sample with our t value [indicated by the dot product] we get the output of all rgb components for that dot product.</br>
[25] Edge Detection with Sobel Filtering : http://setosa.io/ev/image-kernels/</br>
    Doing an averaging of color values at pixel locations on and around each pixel. This is done so with an x direction matrix and a y direction matrix do account for different gradients possible in each direction. These gradients act as the weighting for how much a particular adjacent pixel affects the current pixel being colored. When summing up the final color value, calculate it based on sqrt(xval^2 + yval^2) to yield the final rgb value for that position.</br>
[15] Vignette : https://photographylife.com/what-is-vignetting</br>
    Create a oval blackened area around the screen by checking the distance between the center field of view and where the pixel actually is and using that distance as a weighting of how dark the pixel should be. the farther away, the darker.</br>
[15] Fish-eye bulge: http://gamedev.stackexchange.com/questions/20626/how-do-i-create-a-wide-angle-fisheye-lens-with-hlsl </br>
    Image magnification increased the closer to the center of the screen. Computed based on a combination of using the "aperture" of our camera and the distance to the center of the camera's point of view. </br>
[?] Inverse</br>
    Each color is it's own rgb complement. Just did 1-colorComponent for each component to get opposite hue.</br>
[?] Swap</br>
    Just swapped the r,g,b values with one another.</br>
[?] Chromatic Aberration </br>
    From the pixel location, sampled the rgb values of the pixel shifted in a particular uv direction doing different sampling for the r,g,b components. When the offsetted images come together, you get an overlaying effect of three mario images where it looks like each is a specific color component.

## Images from the Project

Iridescence</br>![Iridescence](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/irid.png "Iridescence")

Inverse</br>![Inverse](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/inverse.png "Inverse")

Chromatic Aberration</br>![Chromatic Aberration](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/chrAberr.png "Chromatic Aberration")

Grayscale</br>![Grayscale](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/grayscale.png "Grayscale")

Sobel Edge Detection</br>![Sobel Edge Detection](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/edgeWithSobel.png "Sobel Edge Detection")

Swap</br>![Swap](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/swap.png "Swap")

Vignette</br>![Vignette](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/vign.png "Vignette")

## Some combinations

Iridescence with Sobel Edge Detection</br>![Iridescence with Sobel Edge Detection](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/iridEdgeWithSobel.png "Iridescence with Sobel Edge Detection")

Iridescence with Swap</br>![Iridescence with Swap](https://github.com/hanbollar/Project5-Shaders/blob/master/images/finished/iridSwap.png "Iridescence with Swap")


