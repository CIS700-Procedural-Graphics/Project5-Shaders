
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float u_coeffs[25];
uniform int u_iterations;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    if (rand(f_uv) > gray * u_amount * 3.0) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
      gl_FragColor =  vec4(1.0, 1.0, 1.0, 1.0);
    }
}
