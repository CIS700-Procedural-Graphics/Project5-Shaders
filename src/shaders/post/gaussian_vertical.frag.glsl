uniform sampler2D tDiffuse;
uniform vec2 SCREEN_SIZE;

varying vec2 f_uv;

void main() {

    vec2 pixelSize = vec2(1.0 / SCREEN_SIZE.x, 1.0 / SCREEN_SIZE.y);
    vec4 outColor = texture2D(tDiffuse, f_uv) * 0.2270270270;

    // Positive 
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * 1.0)) * 0.1945945946;
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * 2.0)) * 0.1216216216;
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * 3.0)) * 0.0540540541;
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * 4.0)) * 0.0162162162;

    // Negative
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * -1.0)) * 0.1945945946;
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * -2.0)) * 0.1216216216;
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * -3.0)) * 0.0540540541;
    outColor += texture2D(tDiffuse, f_uv + vec2(0.0, pixelSize.y * -4.0)) * 0.0162162162;

    gl_FragColor = outColor;
}   