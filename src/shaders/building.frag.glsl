varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vColor;
varying float localHeight;

uniform float time;

// Reference: http://www.iquilezles.org/www/articles/palettes/palettes.htm
vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return saturate(a + b * cos(6.28318 * ( c * t + d)));
}

void main() 
{
	float diff = clamp(dot(vNormal, vec3(1.0, 1.0, 1.0)) * .5 + .5, 0.0, 1.0);

  	float ambientOcclusion = clamp(localHeight, 0.0, 1.0) * .5 + .5;
  	gl_FragColor = vec4(pow(vColor.rgb, vec3(1.4, 1.4, 1.4)) * 2.0 * ambientOcclusion * diff, 1.0);
}