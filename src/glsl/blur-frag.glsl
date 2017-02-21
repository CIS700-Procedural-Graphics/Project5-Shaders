uniform sampler2D tDiffuse;
uniform vec2 u_scale;
uniform float u_std;
varying vec2 f_uv;

#define PI 3.1415926535897932384626433
#define E 2.7182818284590452353602874
#define INV2PI 0.159154943
#define SIZE 8

float luminosity(vec4 color) {
  return (0.2126*color.x + 0.7152*color.y + 0.0722*color.z);
}

float gaussian(float x, float y, float std) {
  float invStdSqr = 1.0 / pow(std, 2.0);
  float exponent = -(pow(x, 2.0) + pow(y, 2.0)) * invStdSqr / 2.0;
  return INV2PI * invStdSqr * exp(exponent);
}

void generateKernel(inout float kernel[SIZE * SIZE]) {
  float total = 0.0;
  float g = 0.0;
  // Precompute gaussian kernel
  for (int i = -SIZE / 2; i <= SIZE / 2; i++) {
    for (int j = -SIZE / 2; j <= SIZE / 2; j++) {
      g = gaussian(float(i), float(j), u_std);
      kernel[(i + SIZE / 2) * SIZE + j] = g;
      total += g;
    }
  }
  // Normalize
  for (int i = 0; i < SIZE * SIZE; i++) {
    kernel[i] /= total;
  }
}

void applyKernel(inout vec4 color, float kernel[SIZE * SIZE]) {
  for (int i = -SIZE / 2; i <= SIZE / 2; i++) {
    for (int j = -SIZE / 2; j <= SIZE / 2; j++) {
      color += texture2D(tDiffuse, f_uv + u_scale * vec2(i,j)) * kernel[(i + SIZE / 2) * SIZE + j];
    }
  }
}

void main() {
  vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
  float kernel[SIZE * SIZE];

  generateKernel(kernel);
  applyKernel(color, kernel);

  gl_FragColor = color;
}
