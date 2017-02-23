 
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

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    vec3 refl = normalize(reflect(f_normal, -u_lightPos + f_position));
    
    vec2 tex = vec2(f_normal.x, f_normal.y) * 0.5 + 0.5;
    // vec2 tex = vec2(refl.x, -refl.y) * 0.5 + 0.5;

    if (u_useTexture == 1) {
        color = texture2D(texture, tex);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    gl_FragColor = color;
}
