uniform sampler2D tDiffuse;

varying vec2 f_uv;

void main() {
    gl_FragColor = texture2D(tDiffuse, f_uv);
}   