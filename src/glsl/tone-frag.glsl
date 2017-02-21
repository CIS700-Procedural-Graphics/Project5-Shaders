uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


uniform vec2 resolution;


// vec3 linearToneMapping(vec3 color)
// {
// 	float exposure = 1.;
// 	color = clamp(exposure * color, 0., 1.);
// 	color = pow(color, vec3(1. / 2.2));
// 	return color;
// }
//
// vec3 filmicToneMapping(vec3 color)
// {
// 	color = max(vec3(0.), color - vec3(0.004));
// 	color = (color * (6.2 * color + .5)) / (color * (6.2 * color + 1.7) + 0.06);
// 	return color;
// }


float cosineInterp(float x, float y, float z)
{
    float t = (1.0 - cos(z * 3.1459)) * 0.5;
    return (x * (1.0 - t)) + (y * t);
}

float randomNoise(float x, float y)
{
    vec2 a = vec2(x, y);
    vec2 b = vec2(12.9898, 78.233);

    float dot_prod = dot(a, b);
    float val = sin(dot_prod) * 43758.5453;
    return fract(val);
}

float smoothedNoise(float x, float y)
{
    float corners = (randomNoise(x - 1.0, y - 1.0) + randomNoise(x + 1.0, y - 1.0) + randomNoise(x - 1.0, y + 1.0) + randomNoise(x + 1.0, y + 1.0)) / 16.0;
    float sides = (randomNoise(x - 1.0, y) + randomNoise(x + 1.0, y) + randomNoise(x , y - 1.0) + randomNoise(x , y + 1.0)) / 8.0;
    float center = randomNoise(x , y) / 4.0;

    return corners + sides + center;
}

//each sample point has a smoothed value, and then you interpolate between those smoothed values rather than the original ones
float interpolatedNoise(float x, float y)
{
    float floored_x = floor(x);
    float difference_x = x - floored_x;

    float floored_y = floor(y);
    float difference_y = y - floored_y;

    float v1 = smoothedNoise(floored_x, floored_y);
    float v2 = smoothedNoise(floored_x + 1.0, floored_y);
    float v3 = smoothedNoise(floored_x, floored_y + 1.0);
    float v4 = smoothedNoise(floored_x + 1.0, floored_y + 1.0);

    float interp_1 = cosineInterp(v1, v2, difference_x);
    float interp_2 = cosineInterp(v3, v4, difference_x);

    return cosineInterp(interp_1, interp_2, difference_y);
}

float perlinNoise(float x, float y)
{
    float noise_total = 0.0;
    float persistence = 0.5;//0.75;  //0.75 makes it spikier. 0.5 makes it more gaseous
    float numOctaves = 2.0;
    float frequency = 0.0;
    float amplitude = 0.0;

    float i = 0.0;

    // const int octaves = int(num_octaves); //8;
    for (int j = 0; j < 20; j+= 1)
    {
        if (j < int(numOctaves)) {
          frequency = pow(2.0, i);
          amplitude = pow(persistence, i);

          //call either randomNoise3D or interpolatedNoise here
          noise_total += interpolatedNoise(x * frequency, y * frequency) * amplitude;
          i++;
        }
    }
    return noise_total;
}


void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    //vec3 _result = linearToneMapping(col.rgb);
		//vec3 _result = filmicToneMapping(col.rgb);
		//gl_FragColor = vec4(  _result, 1.0  );

		//float noise_output = perlinNoise(f_uv.x, f_uv.y);//randomNoise(f_uv.x, f_uv.y);
		float noise_output = randomNoise(f_uv.x, f_uv.y);
		vec2 new_uv = noise_output * 0.05 + f_uv;
		col = texture2D(tDiffuse, new_uv);

    gl_FragColor = vec4( col.rgb , 1.0  );
}
