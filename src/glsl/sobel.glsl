
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

#define e 0.01

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float ep = e * u_amount;

    vec4 ul = texture2D(tDiffuse, vec2(f_uv.x - ep, f_uv.y + ep));
    vec4 um = texture2D(tDiffuse, vec2(f_uv.x, f_uv.y + ep));
    vec4 ur = texture2D(tDiffuse, vec2(f_uv.x + ep, f_uv.y + ep));
    vec4 ml = texture2D(tDiffuse, vec2(f_uv.x - ep, f_uv.y));
    vec4 mr = texture2D(tDiffuse, vec2(f_uv.x + ep, f_uv.y));
    vec4 bl = texture2D(tDiffuse, vec2(f_uv.x - ep, f_uv.y - ep));
    vec4 bm = texture2D(tDiffuse, vec2(f_uv.x, f_uv.y - ep));
    vec4 br = texture2D(tDiffuse, vec2(f_uv.x + ep, f_uv.y - ep));

    vec4 gx = -ul + ur -2.0 * ml + 2.0 * mr - bl + br;
    vec4 gy = ul + 2.0 * um + ur - bl - 2.0 * bm - br;
    vec4 g = sqrt(gx * gx + gy * gy);

    gl_FragColor = g;
}   