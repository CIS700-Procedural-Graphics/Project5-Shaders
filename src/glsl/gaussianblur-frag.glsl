
uniform sampler2D tDiffuse;
uniform float u_radius;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float gaussian(float x, float y) {
  const float PI = 3.14159265258979323846264;
  float sigma = u_radius;

  float t = 1.0 / (2.0 * PI * pow(sigma, 2.0));
  float s = (-1.0 * (pow(x, 2.0) + pow(y, 2.0))) / (2.0 * pow(sigma, 2.0));

  return t * exp(s);
}

void main() {
    const float delta = 0.001;
    vec4 col = vec4(0.0, 0.0, 0.0, 1.0);

    float xMin = u_radius * -1.0;
    float xMax = u_radius;
    float yMin = u_radius * -1.0;
    float yMax = u_radius;

    for (float x = -50.0; x < 10000.0; x++) {
      if (x < xMin) { continue; }
      if (x >= xMax) { break; }

      for (float y = -50.0; y < 10000.0; y++) {
        if (y < yMin) { continue; }
        if (y >= yMax) { break; }

        float u = f_uv.x;
        float v = f_uv.y;

        float u_ = u + (delta * x);
        float v_ = v + (delta * y);
        float weight = gaussian(u, v);
        vec4 col_ = texture2D(tDiffuse, vec2(u_, v_));

        col += (weight * col_);
      }
    }

    gl_FragColor = col;

}