
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float xd = f_uv.x - 0.5;
    float yd = f_uv.y - 0.5;

    float dist = u_amount * sqrt(xd * xd + yd * yd);
    vec4 vignette = mix(vec4(1, 1, 1, 1), vec4(0, 0, 0, 1), dist);

    gl_FragColor = vignette * col;
}   