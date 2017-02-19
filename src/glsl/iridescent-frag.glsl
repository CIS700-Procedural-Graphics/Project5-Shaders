uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_a;
uniform vec3 u_b;
uniform vec3 u_c;
uniform vec3 u_d;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform vec3 u_cameraPos;
uniform float u_lightIntensity;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

// from IQ's site
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  return a + b * cos(6.28318 * ((c * t) + d));
}

void main() {
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    vec3 lookAt = normalize(u_cameraPos - f_position);
    float t = dot(f_normal, lookAt);

    vec3 pal = palette(t, u_a, u_b, u_c, u_d);

    color.rgb = pal;

    gl_FragColor = color;

}