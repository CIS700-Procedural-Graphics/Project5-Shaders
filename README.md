
# Project 5: Shaders

# Pointilism
I computed a random value based on the pixel position and scaled the random value by the darkness. If the probability was above a certain threshold, I made it dark. Otherwise, I made it light.

# Gaussian
I hand calculated the weights for the neighboring pixels for the gaussian blur and used a sigma value of 1 and a kernel size of 3.

# Iridescent
Iridescent was similar to lambert, except that I read from a rainbow texture and used the dot product between the view vector and normal as the uv offset.

# Sobel 
Sobel estimates the gradient magnitude at every pixel to detect edges. 

# Vignette
I did a linear interpolation between a gui variable color and the pixel color. I used the distance to the center as a t value.