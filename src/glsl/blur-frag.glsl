
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


//TODO: add gui features

float computeGaussian(float u, float v) {
	float sigma = 8.5;
	float e = 2.71828;
	float pi = 3.14159;

	float exp = - (u * u + v * v) / (2.0 * sigma * sigma);

	return 1.0 / (2.0 * pi * sigma * sigma) * pow(e, exp);
}

void main() {
	const float radius = 0.01; 
	vec4 col = vec4(0,0,0,1);
	for (float i = -radius; i <= radius; i += 0.001) {
		for (float j = -radius; j <= radius; j += 0.001) {
			vec2 uv = vec2(f_uv[0] + i, f_uv[1] + j);
 	   		col += texture2D(tDiffuse, uv) * computeGaussian(i, j);
 		}
	}

    gl_FragColor = col;
}   
