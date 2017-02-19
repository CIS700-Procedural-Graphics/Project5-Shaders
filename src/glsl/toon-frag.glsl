uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform vec3 u_cameraPos;
uniform float u_lightIntensity;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    d = ceil(d * 1.5) / 1.5;

    color = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);

    vec3 lookAt = normalize(u_cameraPos - f_position);
    float lookAtDotNormal = dot(f_normal, lookAt);

    if (lookAtDotNormal <= 0.5) {
      color = vec4(0.0, 0.0, 0.0, 1.0);
    }

    gl_FragColor = color;
}