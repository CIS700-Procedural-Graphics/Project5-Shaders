varying vec2 f_uv;

uniform sampler2D tDiffuse;
uniform vec2 SCREEN_SIZE;

uniform float time;


float rythm(float x)
{
	x = smoothstep(-1.0, 1.0, sin(x * 7.0));
	x = smoothstep(0.0, 1.0, x);
	x = smoothstep(0.0, 1.0, x);
	return x;
}

void main() {
    
    vec2 pixelSize = vec2(1.0 / SCREEN_SIZE.x, 1.0 / SCREEN_SIZE.y);
    
    vec4 outColor = vec4(0.0);

    float displSmall = sin(f_uv.y * SCREEN_SIZE.y);
    float displBig = sin(f_uv.y * SCREEN_SIZE.y * .05 + time * 12.0) * rythm(time);

    displSmall += displBig;

    outColor.r += texture2D(tDiffuse, f_uv + vec2(pixelSize.x * 32.0, 0.0) * displSmall).r;
    outColor.b += texture2D(tDiffuse, f_uv + vec2(pixelSize.x * -32.0, 0.0) * displSmall).b;
    outColor.g += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * displBig * 32.0)).g;

    gl_FragColor = outColor;
}   