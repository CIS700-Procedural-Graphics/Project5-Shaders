varying vec2 vUv;

uniform float time;

void main() 
{
    float vLines = step(fract((vUv.y + time * .15) * 10.0), time * .25);
    float hLines = step(fract((vUv.x * 1.5 + time * .15) * 10.0), (time - 4.0) * .3);

    float lines = mix(vLines, hLines, step(4.0 - time, 0.0));
	gl_FragColor = vec4(clamp(lines, 0.0, .5));
}