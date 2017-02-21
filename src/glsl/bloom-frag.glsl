
uniform sampler2D tDiffuse;
uniform sampler2D tBuffer;

varying vec2 f_uv;

float luminosity(vec4 color) {
  return (0.2126*color.x + 0.7152*color.y + 0.0722*color.z);
}

void main() {
  vec4 regPass = texture2D(tDiffuse, f_uv);
  vec4 highPass = texture2D(tBuffer, f_uv);
  gl_FragColor = highPass + regPass;
}
