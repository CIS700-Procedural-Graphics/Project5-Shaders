
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float d = u_amount * sqrt((f_uv.x-0.5)*(f_uv.x-0.5) + (f_uv.y-0.5)*(f_uv.y-0.5));
    vec4 vig = mix(vec4(1.0,1.0,1.0,1.0),vec4(0.0,0.0,0.0,1.0), d);
    gl_FragColor = vig * col;
}   