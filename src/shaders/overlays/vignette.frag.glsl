varying vec2 vUv;

uniform sampler2D vignette;
uniform vec2 SCREEN_SIZE;
uniform float time;

void main() 
{
    vec2 pixelSize = vec2(1.0 / SCREEN_SIZE.x, 1.0 / SCREEN_SIZE.y);
    float displSmall = sin(vUv.y * SCREEN_SIZE.y * 3.14) * .5 + .5;
    
    vec4 color = texture2D(vignette, vUv);
	gl_FragColor = mix(color, vec4(.5), displSmall);
}