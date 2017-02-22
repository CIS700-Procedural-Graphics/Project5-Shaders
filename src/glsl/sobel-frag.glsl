uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    
    // Before performing the Sobel convolution, retrieve the 8 neighbors of this fragment
    float epsilon = 0.001; // how close each neighbor is defined to be for edge detection
    
    // Neighbors above (upper left/mid/right)
    vec4 uL = texture2D(tDiffuse, vec2(f_uv.x - epsilon, f_uv.y + epsilon));
    vec4 uM = texture2D(tDiffuse, vec2(f_uv.x, f_uv.y + epsilon));
    vec4 uR = texture2D(tDiffuse, vec2(f_uv.x + epsilon, f_uv.y + epsilon));
    
    // Neighbors to the left and right
    vec4 mL = texture2D(tDiffuse, vec2(f_uv.x - epsilon, f_uv.y));
    vec4 mR = texture2D(tDiffuse, vec2(f_uv.x + epsilon, f_uv.y));
    
    // Neighbors below (left/mid/right)
    vec4 lL = texture2D(tDiffuse, vec2(f_uv.x - epsilon, f_uv.y - epsilon));
    vec4 lM = texture2D(tDiffuse, vec2(f_uv.x, f_uv.y - epsilon));
    vec4 lR = texture2D(tDiffuse, vec2(f_uv.x + epsilon, f_uv.y - epsilon));
    
    // Perform the convolution
    vec4 convX = uL + uM + uM + uR - lL - lM - lM - lR;
    vec4 convY = uR + mR + mR + lR - uL - mL - mL - lL;
    vec4 convolution = sqrt(convX * convX + convY * convY);
    
    // Grayscale the result
    // float gray = dot(convolution.rgb, vec3(0.299, 0.587, 0.114)); 
    vec4 col = texture2D(tDiffuse, f_uv);
    
    gl_FragColor = vec4( /*vec3(gray)*/convolution.rgb, 1 ) * (u_amount) + col * (1.0 - u_amount);
}