
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    // float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    vec3 invert = vec3(1.0 - col.r, 1.0 - col.g, 1.0 - col.b);
    // col.rgb = vec3(invert, invert, invert) * (u_amount) + col.rgb * (1.0 - u_amount);

    gl_FragColor = vec4(invert, 1.0);
}
