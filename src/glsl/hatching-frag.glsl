
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float noise_gen2(float x, float y) {
    return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float r = noise(f_uv.x, f_uv.y);


    float sx = sin(f_uv.x / 10.00) + 1.0; // [0, 2]
    //float sy = sin(f_uv.y / 5.0) + 1.0; // [0, 2]

    //float hatch = (sx + sy) / 4.0; // [0, 1]
    
	float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    if (gray < sx / 2.0) {
    	col.rgb = vec3(0.0, 0.0, 0.0);
    } else {
    	col.rgb = vec3(1.0, 1.0, 1.0);
    }

    //
    //col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);
    gl_FragColor = col;
}   

