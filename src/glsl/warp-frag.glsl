//credits: https://www.shadertoy.com/view/lslGzl

uniform sampler2D tDiffuse;
uniform float u_exposure;
uniform float u_gamma;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 color = texture2D(tDiffuse, f_uv);

    gl_FragColor = vec4(color.rgb, 1.0);
}
