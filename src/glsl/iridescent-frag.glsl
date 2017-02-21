uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 CamPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }
    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    float t = clamp(dot(f_normal, normalize(CamPos - f_position)), 0.0, 1.0);

    //color pallete
    float red = 0.5 + 0.5*(cos(6.28*(t)));
    float green = 0.5 + 0.5*(cos(6.28*(t+0.33)));
    float blue = 0.5 + 0.5*(cos(6.28*(t+0.67)));

    vec3 iridescent_color = vec3(red, green, blue);

    gl_FragColor = vec4(t * d * iridescent_color * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
