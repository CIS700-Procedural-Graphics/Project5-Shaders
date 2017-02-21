
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_viewPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;


float u_bands = 3.0;

float band(float value) {
  return floor(value * u_bands) / u_bands;
}

float intensity(vec3 color) {
  return (color.r + color.g + color.b) / 3.0;
}

vec3 bandColor(vec3 color) {
  float i = intensity(color);
  float i_b = band(i);
  return color * (i_b / i);
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    vec3 u_viewDir = normalize(u_viewPos - f_position);

    if (dot(f_normal, u_viewDir) < 0.4) {
      gl_FragColor = vec4(u_viewDir, 1.0);
    } else {
      gl_FragColor = vec4(bandColor(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient), 1.0);
    }
}
