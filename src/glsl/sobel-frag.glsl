
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform mat3 u_kx;
uniform mat3 u_ky;
varying vec2 f_uv;

void main() {
    mat3 A;
    float step = 0.00077;
    float Gx = 0.0;
    float Gy = 0.0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        vec4 n_col = texture2D(tDiffuse, f_uv + vec2(step * (float(i) - 1.0), step * (float(j) - 1.0)));
        float n_gray = dot(n_col.rgb, vec3(0.299, 0.587, 0.114));
        Gx += n_gray * u_kx[i][j];
        Gy += n_gray * u_ky[i][j];
      }
    }
    gl_FragColor = vec4(vec3(sqrt(pow(Gx, 2.0) + pow(Gy, 2.0))), 1.0);
}
