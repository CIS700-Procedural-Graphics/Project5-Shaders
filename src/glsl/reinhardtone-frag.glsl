//credits: https://www.shadertoy.com/view/lslGzl

uniform sampler2D tDiffuse;
uniform float u_exposure;
uniform float u_gamma;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    col = clamp(col * u_exposure/(1.0 + (col / u_exposure)), 0.0, 1.0);
    float invgamma = 1.0 / u_gamma;

    col = vec4( pow(col.r, u_gamma), pow(col.g, u_gamma), pow(col.b, u_gamma), 1.0);

    gl_FragColor = col;
}
