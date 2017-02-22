varying vec2 vUv;

uniform float time;

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return saturate(a + b * cos(6.28318 * ( c * t + d)));
}

vec3 sampleSky(float t)
{
	// [[-0.162 0.588 1.118] [0.318 0.428 0.500] [1.000 1.000 0.428] [0.000 0.158 0.667]]
	vec3 a = vec3(-0.162, 0.588, 1.118);
	vec3 b = vec3(0.318, 0.428, 0.500);
	vec3 c = vec3(1.000, 1.000, 0.428);
	vec3 d = vec3(0.000, 0.158, 0.667);

	return palette(t, a, b, c, d);
}

float rythm(float x)
{
	x = smoothstep(-1.0, 1.0, sin(x));
	x = smoothstep(0.0, 1.0, x);
	x = smoothstep(0.0, 1.0, x);
	return x;
}

void main() 
{
	float t = vUv.x + vUv.y + time * .15 + rythm(time * 6.28318 * 1.25) * .2 * step(15.0, time) * sin((vUv.x + vUv.y) * 12.0);
    float lines = step(fract(t * 10.0), .25);
    float pattern = length(vUv.yx) * .3 + .4 + lines * .2;

	gl_FragColor = vec4(sampleSky(pattern), 1.0);
}