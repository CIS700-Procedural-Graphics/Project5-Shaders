varying vec2 vUv;
varying vec3 vNormal;

uniform float time;

uniform sampler2D sphereLit;

// Reference: http://www.iquilezles.org/www/articles/palettes/palettes.htm
vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return saturate(a + b * cos(6.28318 * ( c * t + d)));
}

void main() 
{
  	gl_FragColor = vec4(.2 * abs(dot(vNormal, vec3(1,1,1))));
}