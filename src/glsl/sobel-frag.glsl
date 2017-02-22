
uniform sampler2D tDiffuse;
varying vec2 f_uv;
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {

    vec4 col1 = -1.0*texture2D(tDiffuse, vec2(f_uv.x-0.001, f_uv.y-0.001));
    vec4 col2 = -2.0*texture2D(tDiffuse, vec2(f_uv.x-0.001, f_uv.y));
    vec4 col3 = -1.0*texture2D(tDiffuse, vec2(f_uv.x-0.001, f_uv.y+0.001));

    vec4 col4 = 1.0*texture2D(tDiffuse, vec2(f_uv.x+0.001, f_uv.y-0.001));
    vec4 col5 = 2.0*texture2D(tDiffuse, vec2(f_uv.x+0.001, f_uv.y));
    vec4 col6 = 1.0*texture2D(tDiffuse, vec2(f_uv.x+0.001, f_uv.y+0.001));

    vec4 gx = col1 + col2 + col3 + col4 + col5 + col6;


    vec4 col7 = 1.0*texture2D(tDiffuse, vec2(f_uv.x-0.001, f_uv.y-0.001));
    vec4 col8 = 2.0*texture2D(tDiffuse, vec2(f_uv.x, f_uv.y-0.001));
    vec4 col9 = 1.0*texture2D(tDiffuse, vec2(f_uv.x+0.001, f_uv.y-0.001));

    vec4 col10 = -1.0*texture2D(tDiffuse, vec2(f_uv.x-0.001, f_uv.y+0.001));
    vec4 col11 = -2.0*texture2D(tDiffuse, vec2(f_uv.x, f_uv.y+0.001));
    vec4 col12 = -1.0*texture2D(tDiffuse, vec2(f_uv.x+0.001, f_uv.y+0.001));

    vec4 gy = col7 + col8 + col9 + col10 + col11 + col12;

    vec4 g = sqrt(gx*gx + gy*gy);

    gl_FragColor = g;
}   