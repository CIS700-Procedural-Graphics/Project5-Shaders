uniform vec3 uLightDir;
varying vec3 vNormal;
varying vec3 vPos;
#define M_PI 3.1415926535897932384626433832795
#define N_OCTAVES 5


float noise(vec3 seed){
    return fract(sin(dot(seed ,vec3(12.9898,78.233, 157.179))) * 43758.5453);
}

float TotalNoise(vec3 seed, float frequency, float amplitude){ //inside frequency outside amplit
	float n1 = noise(seed * frequency) * amplitude;
	return n1;
}

float lerp(float a, float b, float t){
	return (a * (1.0 - t) + b * t);
}

float cosine_interpolate(float a, float b, float t){
	float cos_t = (1.0 - cos(t * M_PI)) * 0.5;
	return lerp(a, b, cos_t);
}


float trilinearInterpolation(vec3 pos, float frequency, float amplitude){

	vec3 pd = pos * frequency;

	//8 adjacent vec3 positions on lattice
	vec3 v000 = vec3(floor(pd.x),floor(pd.y),floor(pd.z));
	vec3 v100 = vec3(ceil(pd.x),floor(pd.y),floor(pd.z));
	vec3 v010 = vec3(floor(pd.x), ceil(pd.y), floor(pd.z));
	vec3 v001 = vec3(floor(pd.x), floor(pd.y), ceil(pd.z));
	vec3 v101 = vec3(ceil(pd.x), floor(pd.y), ceil(pd.z));
	vec3 v110 = vec3(ceil(pd.x), ceil(pd.y), floor(pd.z));
	vec3 v011 = vec3(floor(pd.x), ceil(pd.y), ceil(pd.z));
	vec3 v111 = vec3(ceil(pd.x), ceil(pd.y), ceil(pd.z));
	
	//noise of cooresponding positions on lattice
	float n000 = TotalNoise(v000, frequency, amplitude);
	float n100 = TotalNoise(v100, frequency, amplitude);
	float n010 = TotalNoise(v010, frequency, amplitude);
	float n001 = TotalNoise(v001, frequency, amplitude);
	float n101 = TotalNoise(v101, frequency, amplitude);
	float n110 = TotalNoise(v110, frequency, amplitude);
	float n011 = TotalNoise(v011, frequency, amplitude);
	float n111 = TotalNoise(v111, frequency, amplitude);

	//time val for interpolation
	float tX = pd.x - floor(pd.x);
	float tY = pd.y - floor(pd.y);
	float tZ = pd.z - floor(pd.z);

	float n00 = cosine_interpolate(n000, n100, tX);
	float n10 = cosine_interpolate(n001, n101, tX);
	float n11 = cosine_interpolate(n011, n111, tX);
	float n01 = cosine_interpolate(n010, n110, tX);
	float n0 = cosine_interpolate(n00, n10, tZ);
	float n1 = cosine_interpolate(n01, n11, tZ);
	float n = cosine_interpolate(n0, n1, tY);

	return n;
}


float PerlinNoise3D(vec3 pos, float freqControl){
	float total = 0.0;
	float persistance = 1.0 / 2.0;

	for (int i = 0 ; i < N_OCTAVES; i++){

		float frequency = pow(2.0, float(i)) * freqControl;
		float amplitude = pow(persistance, float(i));
		total += trilinearInterpolation(pos, frequency, amplitude);

	}

	return total;

}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	float intensity;
	float r; //random number between 0,1;
	float partitions = 3.0;
	
	vec4 white = vec4(1.0,1.0,1.0,1.0);
	vec4 black = vec4(0.0,0.0,0.0,1.0);
	vec4 color = white;


	intensity = dot(uLightDir,vNormal);
	r = noise(vPos);

	// intensity = intensity * partitions;
 // 	intensity = floor(intensity)/partitions;
    
    // float frequency = ((intensity));

 	//if (intensity > 0.95)
	// 	frequency = 1.0;
	// else if (intensity > 0.5)
	// 	frequency = 2.0;
	// else if (intensity > 0.25)
	// 	frequency = 3.0;
	// else
	// 	frequency = 4.0;

	// float amplitude = 1.0/frequency;
	// float perlin = PerlinNoise3D(vPos, frequency);
 // 	vec3 noise_col = vec3(perlin,perlin,perlin);

    // vec3 hsvColor = rgb2hsv(color.rgb);
    // float h = hsvColor.r;

    // hsvColor = hsvColor * 5.0;
    // hsvColor = floor(hsvColor)/5.0;
    // hsvColor.r = h;

    // vec3 rgbColor = hsv2rgb(hsvColor);
    // color = vec4(rgbColor.x,rgbColor.y,rgbColor.z, 1.0);

    if (r > intensity){
    	color = black;
    }

    //color = vec4(noise_col.rgb,1.0);
	
	gl_FragColor = color;

}