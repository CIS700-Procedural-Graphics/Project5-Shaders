
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    float outer_v = 1.0;
    float inner_v = 0.05;

    vec4 final_col = texture2D(tDiffuse, f_uv);
    
    float dist = distance(vec2(0.5,0.5), f_uv); //distance between centre and uv
    
    float vig = clamp((outer_v - dist) / (outer_v - inner_v), 0.0, 1.0 );
    
    final_col *= vig;
    
    gl_FragColor = final_col;
}   