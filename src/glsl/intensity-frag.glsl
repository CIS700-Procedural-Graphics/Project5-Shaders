uniform sampler2D tDiffuse;
uniform int u_radius;
uniform float u_intensity;
uniform vec2 u_scale;
varying vec2 f_uv;

const int MAXRAD = 10;

float intensity(vec4 color) {
  return (color.x + color.y + color.z) / 3.0;
}
// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 color = texture2D(tDiffuse, f_uv);
    

    for (int i = -MAXRAD; i < MAXRAD; i++) {
      if (i < -u_radius || i > u_radius) continue;
      for (int j = -MAXRAD; j < MAXRAD; j++) {
        if (j < -u_radius || j > u_radius) continue;
        color = texture2D(tDiffuse, f_uv + u_scale * vec2(i,j)) * 255.0;
        int curInt = int(intensity(color) * u_intensity / 255.0);
        if (curInt > 255) curInt = 255;
        intensities[curInt]++;
        reds[curInt] += color.r;
        greens[curInt] += color.g;
        blues[curInt] += color.b;
      }
    }


    int curMax = 0;
    int maxIndex = 0;
    for (int i = 0; i < 256; i++) {
      if (intensities[i] > curMax) {
        curMax = intensities[i];
        maxIndex = i;
      }
    }
    vec3 rgb = vec3(reds[maxIndex], greens[maxIndex], blues[maxIndex]) / (255.0 * float(curMax));
    gl_FragColor = vec4(rgb, 1.0);
}
