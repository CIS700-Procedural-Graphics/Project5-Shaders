
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 color = texture2D(tDiffuse, f_uv);

    float u = f_uv.x;
    float v = f_uv.y;
    float diag = 0.707;

    diag *= u_amount;

    float a = distance(f_uv, vec2(0.5)) / diag;
    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);

    gl_FragColor = ((1.0 - a) * color) + (a * black);
}