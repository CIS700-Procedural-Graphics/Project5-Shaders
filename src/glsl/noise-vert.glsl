
varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;
varying float vNoiseValue; 

uniform float u_time;


// Noise functions: 
//------------------------------
float noise_1(float x, float y, float z){
	float value1 = fract(sin(dot(vec2(z, y) ,vec2(81920.03934, 141414.233))) * 1992847.5453);
	float value2 = fract(sin(x) * 102945.5453);

	return dot(value1, value2); 
}

float noise_2(float x, float y, float z) {
	float value1 = fract(sin(dot(vec2(x, y) ,vec2(15.39481, 2394.233))) * 43758.141);
	float value2 = fract(sin(z) * 1039555.54227873);

	return dot(value1, value2); 
}

float noise_3(float x, float y, float z) {
	float n = x * 10100.101 ; 
	float m = y * 10000101101.0001; 
	n = fract(cos(dot(vec2(n,z), vec2(29984.294485, 40201845.9383))) * 3033077.117);
	n = fract(tan(dot(n, m)));
	return n;
}

float noise_4(float x, float y, float z){
	float value1 = fract(sin(dot(vec2(x, y) ,vec2(3427.926341, 9847.91982))) * 18473.5453);
	float value2 = fract(cos(z) * 39857201.5453);

	return fract(dot(value1, value2)); 
}

// Linear Interpolation
float lerp(float a, float b, float t) {
	return a * (1.0 - t) + b * t; 
}

// Cosine Interpolation
float cos_interp(float a, float b, float t) {
	float cos_t = (1.0 - cos(t * 3.14159265358979)) * 0.5;
	return lerp(a , b , cos_t);
}

//----------------------------
// Interpolate Noise function
// Given a position, use surrounding lattice points to interpolate and find influence 
// takes in (x,y,z) position, and the current octave level
float interpolateNoise(float x, float y, float z, int i) {
	// define the lattice points surrounding the input position 
	float x0 = floor(x);
	float x1 = x0 + 1.0; 
	float y0 = floor(y);
	float y1 = y0 + 1.0;
	float z0 = floor(z);
	float z1 = z0 + 1.0; 

	// VALUE BASED NOISE
	vec3 p0 = vec3(x0, y0, z0); vec3 p1 = vec3(x0, y0, z1);
	vec3 p2 = vec3(x0, y1, z0); vec3 p3 = vec3(x0, y1, z1);
	vec3 p4 = vec3(x1, y0, z0); vec3 p5 = vec3(x1, y0, z1);
	vec3 p6 = vec3(x1, y1, z0); vec3 p7 = vec3(x1, y1, z1);

	// use noise function to generate random value
	// depending on the current octave, sample noise using a different function 
	float v0, v1, v2, v3, v4, v5, v6, v7;
	if (i == 0) {
		 v0 = noise_2(p0.x, p0.y, p0.z); v1 = noise_2(p1.x, p1.y, p1.z);
		 v2 = noise_2(p2.x, p2.y, p2.z); v3 = noise_2(p3.x, p3.y, p3.z);
		 v4 = noise_2(p4.x, p4.y, p4.z); v5 = noise_2(p5.x, p5.y, p5.z);
		 v6 = noise_2(p6.x, p6.y, p6.z); v7 = noise_2(p7.x, p7.y, p7.z);
	} else if (i == 1) {
		 v0 = noise_3(p0.x, p0.y, p0.z); v1 = noise_3(p1.x, p1.y, p1.z);
		 v2 = noise_3(p2.x, p2.y, p2.z); v3 = noise_3(p3.x, p3.y, p3.z);
		 v4 = noise_3(p4.x, p4.y, p4.z); v5 = noise_3(p5.x, p5.y, p5.z);
		 v6 = noise_3(p6.x, p6.y, p6.z); v7 = noise_3(p7.x, p7.y, p7.z);
	 } else if (i == 2) {
		 v0 = noise_1(p0.x, p0.y, p0.z); v1 = noise_1(p1.x, p1.y, p1.z);
		 v2 = noise_1(p2.x, p2.y, p2.z); v3 = noise_1(p3.x, p3.y, p3.z);
		 v4 = noise_1(p4.x, p4.y, p4.z); v5 = noise_1(p5.x, p5.y, p5.z);
		 v6 = noise_1(p6.x, p6.y, p6.z); v7 = noise_1(p7.x, p7.y, p7.z);
	} else {
		 v0 = noise_4(p0.x, p0.y, p0.z); v1 = noise_4(p1.x, p1.y, p1.z);
		 v2 = noise_4(p2.x, p2.y, p2.z); v3 = noise_4(p3.x, p3.y, p3.z);
		 v4 = noise_4(p4.x, p4.y, p4.z); v5 = noise_4(p5.x, p5.y, p5.z);
		 v6 = noise_4(p6.x, p6.y, p6.z); v7 = noise_4(p7.x, p7.y, p7.z);
	}

	// trilinear interpolation of all 8 values
	// coordinates in the unit cube: 
	float unitX = x - x0;
	float unitY = y - y0;
	float unitZ = z - z0;

	float xCos1 = cos_interp(v0, v4, unitX);
	float xCos2 = cos_interp(v1, v5, unitX);
	float xCos3 = cos_interp(v2, v6, unitX);
	float xCos4 = cos_interp(v3, v7, unitX);

	float yCos1 = cos_interp(xCos1, xCos3, unitY);
	float yCos2 = cos_interp(xCos2, xCos4, unitY);

	float average = cos_interp(yCos1, yCos2, unitZ);

	return average;
}

// multioctave noise generation
float fbm(float x, float y, float z) {
	float total = 0.0; 
	const int OCTAVES = 4;
	// float u_persistance = 4.0;

	// loop for some number of octaves
	for(int i = 0; i < OCTAVES; i++) {
		float i_float = float(i);
		float frequency = pow(2.0, i_float);
		float amplitude = pow(4.0, i_float);

		// use interpolate noise function to find noise value
        float sampleNoise = interpolateNoise(x * frequency , y * frequency , z * frequency, 4 - i);
        total += sampleNoise * amplitude;
	}

	return total;
}

float fbm2(float x, float y, float z) {
	float total = 0.0; 
	const int OCTAVES = 4;
	// float u_persistance = 4.0;

	// loop for some number of octaves
	for(int i = 0; i < OCTAVES; i++) {
		float i_float = float(i);
		float frequency = pow(2.0, i_float);
		float amplitude = pow(4.0, i_float);

		// use interpolate noise function to find noise value
        float sampleNoise = interpolateNoise(x * frequency , y * frequency , z * frequency, i);
        total += sampleNoise * amplitude;
	}

	return total;
}


// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    // f_uv = uv;
    f_normal = normal;
    f_position = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

    // alter positions based on noise function
    // add in the animation later meybe
    // float timeMod = u_time / 300.0; 
    float noiseHeight = fbm(
    	float(uv.x) , 
    	float(uv.y) , 
    	float(position.z) );

    vec3 noisyPosition = vec3(
    	uv.x + noiseHeight / 100.0, 
    	uv.y + noiseHeight / 100.0 , 
    	position.z ); 

    float noiseHeight2 = fbm2(
    	uv.x + noisyPosition.x, 
    	uv.y + noisyPosition.y, 
    	position.z + noisyPosition.z); 

    vec3 noisyPosition2 = (vec3(
    noisyPosition.x + noiseHeight2 , 
    noisyPosition.y + noiseHeight2 , 
    position.z )); 

    f_uv = vec2(noisyPosition2.x, noisyPosition2.y); 

    // vNoiseValue = noiseHeight2;

    // gl_Position = projectionMatrix * modelViewMatrix * vec4(noisyPosition2, 1.0 );

}