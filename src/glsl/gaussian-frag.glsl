
uniform sampler2D tDiffuse;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float uvIncr = 0.002;
    
    vec2 uv01 = f_uv + vec2(0.0,uvIncr);
    vec2 uv0n1 = f_uv + vec2(0.0, -uvIncr);

    vec2 uv10 = f_uv + vec2(uvIncr, 0.0);
    vec2 uvn10 = f_uv + vec2(-uvIncr, 0.0);

    vec4 col1 = texture2D(tDiffuse, uv01);
    vec4 col2 = texture2D(tDiffuse, uv0n1);
    vec4 col3 = texture2D(tDiffuse, uv10);
    vec4 col4 = texture2D(tDiffuse, uvn10);

    col = (col1 + col2 + col3 + col4)/4.0;
    col[3] = 1.0;

    // vec2 uv11 = f_uv + vec2(1.0, 0.0);
    // vec2 uvn11 = f_uv + vec2(-1.0, 0.0);
    // vec2 uv1n1 = f_uv + vec2(-1.0, 0.0);



    gl_FragColor = col;
}   