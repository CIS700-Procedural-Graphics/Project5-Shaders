uniform sampler2D tDiffuse;
uniform int u_radius;
uniform float u_intensity;
uniform vec2 u_scale;
varying vec2 f_uv;

#define MAXRAD 10
#define INTENSITY 6

float intensity(vec4 color) {
  return (color.x + color.y + color.z) / 3.0;
}
// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    vec4 color;
    int intensities[INTENSITY];
    float reds[INTENSITY];
    float greens[INTENSITY];
    float blues[INTENSITY];
    for (int h = 0; h < INTENSITY; h++) {
      for (int i = -MAXRAD; i < MAXRAD; i++) {
        if (i < -u_radius || i > u_radius) continue;
        for (int j = -MAXRAD; j < MAXRAD; j++) {
          if (j < -u_radius || j > u_radius) continue;
          color = texture2D(tDiffuse, f_uv + u_scale * vec2(i,j));
          int curInt = int(intensity(color) * float(INTENSITY - 1));
          if (h == curInt) {
            intensities[h]++;
            reds[h] += color.r;
            greens[h] += color.g;
            blues[h] += color.b;
          }
        }
      }
    }


    int curMax = 0;
    vec3 rgb;
    for (int i = 0; i < INTENSITY; i++) {
      if (intensities[i] > curMax) {
        curMax = intensities[i];
        rgb = vec3(reds[i], greens[i], blues[i]) / float(curMax);
      }
    }
    gl_FragColor = vec4(rgb, 1.0);
}
