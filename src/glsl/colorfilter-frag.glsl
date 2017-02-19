uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    vec3 aquamarine = vec3(55.0/255.0, 237.0/255.0, 1.0);
    aquamarine *= col.rgb;

    col.rgb = aquamarine * (u_amount) + col.rgb * (1.0 - u_amount);

    gl_FragColor = col;
}