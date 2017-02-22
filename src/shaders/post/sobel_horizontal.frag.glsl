varying vec2 f_uv;

uniform sampler2D tDiffuse;
uniform sampler2D tOriginal;
uniform vec2 SCREEN_SIZE;

void main() {
    
    vec2 pixelSize = vec2(1.0 / SCREEN_SIZE.x, 1.0 / SCREEN_SIZE.y);
    
    vec4 outColor = vec4(0.0);

    outColor += texture2D(tOriginal, f_uv + pixelSize * vec2(1.0, 1.0)) * 1.0;
    outColor += texture2D(tOriginal, f_uv + pixelSize * vec2(1.0, 0.0)) * 2.0;
    outColor += texture2D(tOriginal, f_uv + pixelSize * vec2(1.0, -1.0)) * 1.0;

    outColor -= texture2D(tOriginal, f_uv + pixelSize * vec2(-1.0, 1.0)) * 1.0;
    outColor -= texture2D(tOriginal, f_uv + pixelSize * vec2(-1.0, 0.0)) * 2.0;
    outColor -= texture2D(tOriginal, f_uv + pixelSize * vec2(-1.0, -1.0)) * 1.0;

    gl_FragColor = abs(outColor);
}   