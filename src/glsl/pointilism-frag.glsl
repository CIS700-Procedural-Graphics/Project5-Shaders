// change the color of the points as well!

uniform sampler2D tDiffuse;
uniform float u_amount;
uniform vec3 u_color;
varying vec2 f_uv;


// our favorite SO glsl random function! 
float rand(float x, float y, float z){
    return fract(sin(dot(vec3(x, y, z), vec3(12.9898, 12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    // since r, g, b values are between 0.0 and 1.0, we can just take the length of the components
    // and treat that as a probability. Thus, (r, g, b) = (0, 0, 0) would mean the length
    // of the rgb vector would be 0, and thus, any value of the scaled probability
    // would cause this pixel to be black. 
    float threshold = length(vec3(col));

    // the probability of coloring this pixel should scale with the original darkness.
    // we divide by threshold because the darker this pixel is, the higher our p value
    // will be to color it dark. A higher p value is more significant as statistics teaches
    // us, so when pval > threshold we should draw a pixel black and reject the null hypothesis.  
    // float pval = rand(f_uv.x, f_uv.y, 1.0) * (u_amount * 2.5) / threshold;
    float pval = rand(f_uv.x, f_uv.y, 1.0) * (u_amount * 2.5) / threshold;
    if (pval > threshold) {
    	gl_FragColor = vec4(u_color, 1.0);
    }
    else {
    	gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }

}

