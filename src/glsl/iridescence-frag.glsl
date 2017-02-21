
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
varying vec3 f_ray;

void main() {
    float pi = 3.141592653589;
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        float x = 0.5 * dot(f_normal.rgb, f_ray) + 0.5;
        color = vec4(0.5 * cos(2.5 * x / pi) + 0.5,
                     0.5 * cos(2.5 * x / pi + (pi / 3.0)) + 0.5,
                     0.5 * cos(2.5 * x / pi + (2.0 * pi / 3.0)) + 0.5,
                     1.0);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
