
uniform sampler2D tDiffuse;
uniform float u_time;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    float u = f_uv.x;
    float v = f_uv.y;
    float amplitude = 0.01;
    float rate = 10.0;
    float twoPI = 2.0 * 3.141592;

    u += amplitude * sin((v * twoPI * rate) + u_time);
    v += amplitude * sin((u * twoPI * rate) + u_time);

    vec4 col = texture2D(tDiffuse, vec2(u, v));

    gl_FragColor = col;
}