
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform vec3 u_color;
uniform float u_width;
uniform float u_height;
varying vec2 f_uv;

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    // set origin
    vec2 mid_point = vec2(0.5, 0.5);
    float dist = length(mid_point - f_uv);
    float vignette = clamp((2.0 - dist * dist) / (2.0 - 0.05), 0.0, 1.0);
    gl_FragColor = vec4(col.rgb * vignette * u_amount + u_color * 0.5, 1.0);

}

