varying vec2 vUv;

uniform float time;
uniform float ASPECT_RATIO;

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return saturate(a + b * cos(6.28318 * ( c * t + d)));
}

vec3 sampleColor(float t)
{
	//[[0.938 0.328 0.718] [0.659 0.438 0.328] [0.388 0.388 0.296] [2.538 2.478 0.168]]

	vec3 a = vec3(0.938, 0.328, 0.718);
	vec3 b = vec3(0.659, 0.438, 0.328);
	vec3 c = vec3(0.388, 0.388, 0.296);
	vec3 d = vec3(2.538, 2.478, 0.168);

	return palette(t, a, b, c, d);
}

float rythm(float x)
{
	x = smoothstep(-1.0, 1.0, sin(x));
	x = smoothstep(0.0, 1.0, x);
	x = smoothstep(0.0, 1.0, x);
	return x;
}


// Color palette approach
vec3 hsv2rgb_p(vec3 c) 
{
    float h = c.x;
    float s = c.y * c.z;
    float s_n = c.z - s * .5;
    
    // Can remove some parameters, but I'll leave them as reference	
    return palette(h, vec3(s_n), vec3(s), vec3(1.0), vec3(1.0, 0.667, .334));
}

float fun(float t, float m, float a, float n1, float n2, float n3)
{
	float term1 = pow(abs(cos(m * t * .25) / a), n2);
	float term2 = pow(abs(sin(m * t * .25) / a), n3);
	return pow(term1 + term2, -1.0 / n1);
}

float hash2D(vec2 x)
{
	float i = dot(x, vec2(123.4031, 46.5244876));
	return fract(sin(i * 7.13) * 268573.103291);
}

float evaluateFun(vec2 p, float m, float random)
{
	// + rythm(time*6.28318) * .5
	float t = mod(atan(p.y, p.x) + time, 6.28318);

	float l = length(p);
	vec3 r = hsv2rgb_p(vec3(random, 1.0, 1.0));
	float radius = fun(t, m, (r.x + r.z) * .6, r.x * 5.0, (r.y + rythm(time * 6.0) * .5) * 5.0, r.z * 10.0 + 2.0);

	return smoothstep(l, l + .025, radius);
}

void main() 
{
 	vec2 p = vUv * 16.0 + vec2(time * 2.0);
 	p.y *= ASPECT_RATIO;

 	vec2 fP = floor(p) + vec2(.5, .5);

 	float random = hash2D(fP);

 	float l = length(p - fP);

 	float polkaSize = .1 + rythm(time * 6.28318 * 1.5) * .1;
 	polkaSize += (vUv.x + vUv.y) * .1;

 	float polka = smoothstep(l, l + .015, polkaSize);

 	float f = evaluateFun((p - fP) * (2.0 - rythm(time*6.28318) * 1.0), length(mod(floor(p), vec2(16.0))) * .5 + 1.0 + rythm(time * 12.0), random);

	gl_FragColor = vec4(sampleColor(f * (vUv.x + vUv.x)), 1.0);
}