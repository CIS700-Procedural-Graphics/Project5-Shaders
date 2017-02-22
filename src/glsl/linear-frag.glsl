
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    col = clamp(col, vec4(0.0), vec4(1.0));
    col = pow(col, vec4(vec3(1.0 / u_amount), 1.0));

    gl_FragColor = col;
}   