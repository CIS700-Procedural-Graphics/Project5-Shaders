
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

// Generic random noise generator
// https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float rand(vec2 c){ return fract(sin(dot(c.xy, vec2(12.9898,78.233))) * 43758.5453); }

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float prob = length(col.rgb) / length(vec3(0.5, 0.5, 0.5));
    float noise = rand(f_uv);

    if (noise < prob) {
      gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
}