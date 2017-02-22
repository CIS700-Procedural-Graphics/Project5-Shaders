uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    
    float center_uvX = f_uv.x - 0.5;
    float center_uvY = f_uv.y - 0.5;
    float distFromCenter = length(vec2(center_uvX, center_uvY));
    distFromCenter = 1.0 - distFromCenter;
    gl_FragColor = col * distFromCenter * (u_amount) + col * (1.0 - u_amount);
}