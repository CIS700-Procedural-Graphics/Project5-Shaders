
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

    float new_d = d*5.0;
    new_d = floor(new_d);
    new_d = new_d/5.0;
    float blackoutline = clamp(dot(f_normal, normalize(CamPos - f_position)), 0.0, 1.0);
    blackoutline = blackoutline * 10.0;
    blackoutline = floor(blackoutline)/10.0;
    if(blackoutline < 0.4) blackoutline =0.0;
    else blackoutline= 1.0;

    gl_FragColor = vec4(blackoutline*new_d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
