
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
uniform float u_rand[6];

void main() {

    vec4 col = texture2D(tDiffuse, f_uv);
    float step = 0.005 * (u_rand[3] - 0.5);

    // RGB Glitch
    if (u_rand[0] < 0.8 * u_amount) {
      vec4 r_shift_col = texture2D(tDiffuse, f_uv + vec2(step, step));
      vec4 g_shift_col = texture2D(tDiffuse, f_uv + vec2(-step, step));
      vec4 b_shift_col = texture2D(tDiffuse, f_uv + vec2(step, -step));
      col.rgb = vec3(r_shift_col.r, g_shift_col.g, b_shift_col.b);
    }

    // Gray Glitch
    if (u_rand[1] < 0.4 * u_amount) {
      vec2 shift1 = vec2(0.2 * (u_rand[1] - 0.5), 0.0);
      vec4 shift_col1 = texture2D(tDiffuse, f_uv + shift1);
      vec2 shift2 = vec2(0.2 * (u_rand[2] - 0.5), 0.0);
      vec4 shift_col2 = texture2D(tDiffuse, f_uv + shift2);
      vec2 shift3 = vec2(0.2 * (u_rand[3] - 0.5), 0.0);
      vec4 shift_col3 = texture2D(tDiffuse, f_uv + shift3);

      float gray1 = dot(shift_col1.rgb, vec3(0.299, 0.587, 0.114));
      float gray2 = dot(shift_col2.rgb, vec3(0.299, 0.587, 0.114));
      float gray3 = dot(shift_col3.rgb, vec3(0.299, 0.587, 0.114));

      if (f_uv.y > u_rand[0] && f_uv.y < u_rand[1]) {
        col.rgb = vec3(gray1, gray1, gray1) * (u_amount) + col.rgb * (1.0 - u_amount);
      }
      if (f_uv.y > u_rand[2] && f_uv.y < u_rand[3]) {
        col.rgb = vec3(gray2, gray2, gray2) * (u_amount) + col.rgb * (1.0 - u_amount);
      }
      if (f_uv.y > u_rand[4] && f_uv.y < u_rand[5]) {
        col.rgb = vec3(gray3, gray3, gray3) * (u_amount) + col.rgb * (1.0 - u_amount);
      }
    }

    gl_FragColor = col;
}
