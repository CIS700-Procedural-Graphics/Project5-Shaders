
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    col.rgb = vec3(1.0 - col[0], 1.0 - col[1], 1.0 - col[2]) * (u_amount) + col.rgb * (1.0 - u_amount);

    gl_FragColor = col;
}   