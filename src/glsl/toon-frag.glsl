
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;
varying float f_border;

vec3 toonify(vec3 color) {
    float f = 12.5;
    int i = 6;
    float t = f / float(i);
    vec3 toon_color = vec3(
        float(int(color.x * f) / i) / t,
        float(int(color.y * f) / i) / t,
        float(int(color.z * f) / i) / t
      );
    return toon_color;
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    vec3 lambert_color = d * color.rgb * u_lightCol * u_lightIntensity + u_ambient;
    vec3 toon_color = toonify(lambert_color);

    if (f_border < 0.6) {
      gl_FragColor = vec4(0,0,0, 1.0);
    } else {
      vec3 hsv_toon_color = rgb2hsv(toon_color);
      hsv_toon_color.r -= 0.0;
      hsv_toon_color.g -= 0.1;
      vec3 rgb_toon_color = hsv2rgb(hsv_toon_color);
      gl_FragColor = vec4(rgb_toon_color, 1.0);
    }
}
