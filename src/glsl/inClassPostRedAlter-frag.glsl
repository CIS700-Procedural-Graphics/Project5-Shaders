
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
	vec4 col = texture2D(tDiffuse, f_uv);
    float r = col[0];
    float g = col[1];
    float b = col[2];
    col.rgb = vec3(g, r, b);
    gl_FragColor = col;
}   