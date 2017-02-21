
uniform sampler2D tDiffuse;
uniform float u_threshold;
uniform float u_kernel[9];
uniform vec2 u_scale;
varying vec2 f_uv;


float intensity(vec4 color) {
  return (color.x + color.y + color.z) / 3.0;
}

void main() {
  vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(-1, -1)) * 1.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(0, -1)) * 2.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(1, -1)) * 1.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(-1, 0)) * 0.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(1, 0)) * 0.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(-1, 1)) * -1.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(0, 1)) * -2.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(1, 1)) * -1.0;

  if (intensity(color) > u_threshold) {
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    return;
  }
  color = vec4(0.0, 0.0, 0.0, 1.0);
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(-1, -1)) * -1.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(0, -1)) * 0.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(1, -1)) * 1.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(-1, 0)) * -2.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(1, 0)) * 2.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(-1, 1)) * -1.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(0, 1)) * 0.0;
  color += texture2D(tDiffuse, f_uv + u_scale * vec2(1, 1)) * 1.0;

  if (intensity(color) > u_threshold) {
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    return;
  }

  gl_FragColor = texture2D(tDiffuse, f_uv);
}
