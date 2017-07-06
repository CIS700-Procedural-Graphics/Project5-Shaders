
uniform sampler2D tDiffuse;
uniform float u_exposure;

varying vec2 f_uv;

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    col.rgb = vec3(1.0) - exp(-col.rgb * u_exposure);
    //col.rgb = pow(col.rgb, vec3(0.4545));
    gl_FragColor = col;
}   