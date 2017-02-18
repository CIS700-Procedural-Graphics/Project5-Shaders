
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float noise_gen2(float x, float y) {
    return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}


void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    // Generate noise here vs in the vertex shader makes a difference for some reason
    float noise = noise_gen2(f_uv.x, f_uv.y);
    
    if (gray < noise) {
    	col.rgb = vec3(0.0, 0.0, 0.0);
    } else {
    	col.rgb = vec3(1.0, 1.0, 1.0);
    }

    gl_FragColor = col;
}   

