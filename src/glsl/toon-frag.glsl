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
varying vec3 f_cameraPos;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    d = floor(d * 5.0) / 5.0; // distinct steps in shading

    float outline = clamp(dot(f_normal, f_cameraPos), 0.0, 0.3);
    outline = floor(outline * 4.0);

    gl_FragColor = vec4(outline * d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}