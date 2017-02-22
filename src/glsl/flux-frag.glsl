
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform vec3 u_color;
varying vec2 f_uv;

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    col.rgb = u_color * (u_amount) + col.rgb * (1.0 - u_amount);
    gl_FragColor = col;

}

