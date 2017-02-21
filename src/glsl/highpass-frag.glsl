uniform sampler2D tDiffuse;
uniform float threshold;
varying vec2 f_uv;

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float intensity = dot(col.rgb, col.rgb);
    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
    if (intensity > threshold) col = white;
    else col = black;

    gl_FragColor = col;
}   