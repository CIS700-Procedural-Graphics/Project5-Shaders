
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
// References

float noise_gen1(float x) {
	return fract(sin(x) * 54582.5453);
}

float noise_gen2(float x, float y) {
    return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float r = noise_gen2(f_uv.x, f_uv.y);
    float rr = noise_gen1(f_uv.x * f_uv.y);


    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	float s = sin((f_uv.x + f_uv.y) * u_amount) + 1.0;
	float ss = sin((f_uv.x - f_uv.y) * u_amount) + 1.0;

    if (r >= (s + ss) / 4.0 || gray >= r) {
    	col.rgb = vec3(1.0, 1.0, 1.0);
    }

    gl_FragColor = col;
}   

