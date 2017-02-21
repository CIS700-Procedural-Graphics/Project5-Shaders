
uniform sampler2D tDiffuse;
uniform float u_threshold;
uniform vec2 u_scale;
uniform float u_std;
varying vec2 f_uv;

#define PI 3.1415926535897932384626433
#define E 2.7182818284590452353602874
#define INV2PI 0.159154943
#define SIZE 15

float intensity(vec4 color) {
  return (color.x + color.y + color.z) / 3.0;
}

float luminosity(vec4 color) {
  return (0.2126*color.x + 0.7152*color.y + 0.0722*color.z);
}

void main() {
  vec4 texColor = texture2D(tDiffuse, f_uv);
  if (luminosity(texColor) > u_threshold) {
    gl_FragColor = texColor;
    return;
  }
  gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
