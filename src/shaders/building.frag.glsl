varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vColor;
varying vec4 wsPos;
varying float localHeight;

uniform float time;
uniform float animateHeight;

// Reference: http://www.iquilezles.org/www/articles/palettes/palettes.htm
vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return saturate(a + b * cos(6.28318 * ( c * t + d)));
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

void main() 
{
	float diff = clamp(dot(vNormal, vec3(1.0, 1.0, 1.0)) * .75 + .25, 0.0, 1.0);
  	float ambientOcclusion = clamp(localHeight, 0.0, 1.0) * .5 + .5;

  	float displ = fract(diff * .75 + vColor.r + (wsPos.x + wsPos.y) * .25 + time * .2 + rythm(time * 7.0) * .2 * animateHeight);
  	gl_FragColor = vec4(hsv2rgb_p(vec3(displ, diff * .6 + .4, ambientOcclusion)), 1.0);
}