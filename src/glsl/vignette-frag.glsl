
uniform sampler2D tDiffuse;
uniform float u_edge0;
uniform float u_edge1;
uniform float u_width;
uniform float u_height;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
// References:
//     Smooth Step: http://www.shaderific.com/glsl-functions/

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    vec2 centerToFrag = f_uv - vec2(0.5, 0.5);
    float len = length(centerToFrag) / 0.707;
    
    float result = smoothstep(u_edge0, u_edge1, 1.0 - len);
    gl_FragColor = vec4(result * col.rgb, 1.0);
}   