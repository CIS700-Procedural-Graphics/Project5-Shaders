
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
varying vec3 fPos;

float noise(float x, float y){
	float value1 = fract(sin(dot(vec2(x, y) ,vec2(1027.9898, 29381.233))) * 333019.5453);

	return dot(value1, 14958832.22); 
}

float noise_3(float x, float y, float z) {
	float n = x * 109277.101 ; 
	float m = y * 101010010.0001; 
	n = fract(cos(dot(vec2(n,z), vec2(19469.294485, 128282.9383))) * 1094877.1293);
	n = fract(tan(dot(n, m)));
	return n;
}

float noise_4(float x, float y, float z){
	float value1 = fract(sin(dot(vec2(x, y) ,vec2(3427.9898, 9847.233))) * 202.5453);
	float value2 = fract(cos(z) * 20247.5453);

	return fract(dot(value1, value2)); 
}

float noise_1(float x, float y, float z){
	float value1 = fract(sin(dot(vec2(z, y) ,vec2(1027.9898, 29381.233))) * 333019.5453);
	float value2 = fract(sin(x) * 43758.5453);

	return dot(value1, value2); 
}

void main() {
	float noiseValue = noise_3(fPos.x / 200.0, fPos.y / 200.0, fPos.z / 200.0); 
	// float noiseValue1 = noise_1(fPos.x/ 100.0, fPos.y / 100.0, fPos.z / 100.0);
	float totalNoise = 1.0 * noiseValue; // + 0.1 * noiseValue1;
	// float totalNoise = noise(fPos.x, fPos.y);
	if (totalNoise > 0.5) {
		// gl_FragColor = vec4(0.0,0.0,0.0,1.0); 
		gl_FragColor = vec4(0.294, 0.290, 0.282,1.0);
	} else {
	    vec4 col = texture2D(tDiffuse, f_uv);
	    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

	    col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

	    gl_FragColor = col;	
	}
    // vec4 col = texture2D(tDiffuse, f_uv);
    // float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    // col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    // gl_FragColor = col;
}   