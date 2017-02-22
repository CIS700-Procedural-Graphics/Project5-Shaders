varying vec2 f_uv;
uniform sampler2D tDiffuse;
uniform float pixellateFactor;

void main() {
    vec2 p = f_uv.xy;

    p.x -= mod(p.x, 1.0 / pixellateFactor);
    p.y -= mod(p.y, 1.0 / pixellateFactor);
    
    vec3 col = texture2D(tDiffuse, p).rgb;
    gl_FragColor = vec4(col, 1.0);
}