
# Project 5: Shaders

### Instagram-Like Filters
- Gaussian blur (currently named as Bloom in project):
    
    Read up on the Gaussian algorithm here: http://www.pixelstech.net/article/1353768112-Gaussian-Blur-Algorithm
    Used a two-dimensional Gaussian function to output the weights of influence for each neighboring pixel. The number of neighboring pixel samples is dependent on the u_amount slider. The width and the height are always equal and set as odd numbers to keep observed pixel at center. Applied the Gaussian weight to neighboring pixel colors, summed the colors as the observed pixel output color.

- Iridescence: 
    
    Found the camera forward vector by subtracting the observed vertex from the camera position (although traditionally the camera forward vector should be passed in, except it is not a parameter of the camera object in THREE.js). Took the dot product between vertex normal and camera forward vector, passed it in as the t value for IQ's cosine color-mapping method, weighted it by half, and combined it with the albedo color.

- Pointilism:
    
    Determined the brightness of the observed pixel in a range from 0 to 1. Brightness of 0 has 0% chance of drawing a white dot, brightness of 1 has a 100% chance of drawing a white dot. Used a random seed generator to pick probability, and drew point/no point accordingly.

### Advanced Post-Processing: 
- Noise Warp: 
    
    Used the noise function written in Project 1 and applied it as an offset to the texture sampling. Passed in time as a uniform variable to the fragment shader so that the warp is animated. The u_amount slider adjusts the offset factor that is multiplied by the noise function.

- Edge detection with Sobel filtering: 
    
    Read up on Sobel filtering here: https://en.wikipedia.org/wiki/Sobel_operator.
    Took the approximate horizontal derivative (Gx) of 6 neighboring pixels, took the approximate vertical derivative (Gy) of 6 neighboring pixels. Applied Gx and Gy to the 6 neighboring pixel colors respectively, and added them up. Took the square root of the sum of the squares of Gx and Gy, set it as the output color.