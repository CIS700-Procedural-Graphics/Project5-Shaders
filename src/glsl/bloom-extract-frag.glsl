
uniform sampler2D tDiffuse;
uniform float u_threshold;
varying vec2 f_uv;
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float brightness = 0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b;
    
    if (brightness < u_threshold) {
        //remove the color
    	col.rgb = vec3(0, 0, 0);
    }

    gl_FragColor = col;
}   