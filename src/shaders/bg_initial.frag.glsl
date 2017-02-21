varying vec2 vUv;

uniform float time;

void main() 
{
    float lines = step(fract((vUv.x + vUv.y + time * .15) * 10.0), .25);
	gl_FragColor = vec4(length(vUv.yx) * .3 + .4 + lines * .2);
}