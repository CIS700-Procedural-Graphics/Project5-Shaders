
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;


float noise_gen1(float x) {
	return fract(sin(dot(vec2(x, x) ,vec2(12.9898,78.233))) * 43758.5453);

}

float gray (vec2 uv) {
	vec4 col = texture2D(tDiffuse, uv);
	return dot(col.rgb, vec3(0.299, 0.587, 0.114));
}

float pattern (vec2 p) {
	vec2 q = vec2(gray(p+ noise_gen1(p[0]) ),
				  gray(p + noise_gen1(p[1]) ));
	return gray(p + q * 0.2);
} 



// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
	// float offset = noise_gen1(f_uv[0], f_uv[1]) / 80.0;
	// vec2 uv = f_uv;
	// uv[0] = noise_gen1(uv[0] + 
	// 		noise_gen1(uv[0])) / 50.0;

	// uv[1] =  noise_gen1(uv[1] + 
	// 		noise_gen1(uv[1])) / 50.0;

	// f_uv = uv;

    // vec4 col = texture2D(tDiffuse, uv);
    // float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    float gray = pattern(f_uv);
    vec4 col = texture2D(tDiffuse, f_uv);
    col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    
    // col.r += offset;
    // col.g += offset;
    // col.b += offset;


    gl_FragColor = col;
}   