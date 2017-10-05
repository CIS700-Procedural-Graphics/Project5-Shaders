//credits: https://www.shadertoy.com/view/lslGzl

uniform sampler2D tDiffuse;
uniform float u_exposure;
uniform float u_gamma;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    vec3 tempcol = max(vec3(0.0), col.rgb - vec3(0.004));
  	tempcol = (tempcol * (6.2 * tempcol + .5)) / (tempcol * (6.2 * tempcol + 1.7) + 0.06);

    gl_FragColor =vec4(tempcol, 1.0);
}
