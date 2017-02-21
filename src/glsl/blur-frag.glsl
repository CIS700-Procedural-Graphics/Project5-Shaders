
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float u_coeffs[25];
uniform int u_iterations;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 sums[25];
    vec4 col = texture2D(tDiffuse, f_uv);
    float step = u_amount;
    for (int i = -2; i < 3; i++) {
      for (int j = -2; j < 3; j++) {
        float coeff = u_coeffs[(i + 2) * 5 + (j + 2)];
        vec2 uv = vec2(f_uv.x + float(i) * step,
                       f_uv.y + float(j) * step);
        col += coeff * texture2D(tDiffuse, uv);
      }
    }

    gl_FragColor = col / 273.0;
}
