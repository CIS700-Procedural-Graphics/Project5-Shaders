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

#define PI 3.1415926535897932384626433832795

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    //iridescent is view dependent
    float d = clamp(dot(f_normal, normalize(cameraPosition - f_position)), 0.0, 1.0);

    //plug in cosine palette function
    vec3 _a = vec3(0.5, 0.5, 0.5);
    vec3 _b = vec3(0.5, 0.5, 0.5);
    vec3 _c = vec3(1.0, 1.0, 1.0);
    vec3 _d = vec3(0.0, 0.33, 0.67);
    vec3 result = _a + _b * cos(2.0 * PI * (_c * d + _d));

    //lerp with albedo
    float lerp_x = ((1.0 - d) * result[0]) + (u_albedo[0] * d);
    float lerp_y = ((1.0 - d) * result[1]) + (u_albedo[1] * d);
    float lerp_z = ((1.0 - d) * result[2]) + (u_albedo[2] * d);
    color = vec4(lerp_x, lerp_y, lerp_z, 1.0);

    gl_FragColor = vec4(result.xyz, 1.0);
}
