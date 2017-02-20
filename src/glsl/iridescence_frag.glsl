
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

// cosine palette function by Inigo Quiles 
vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d)
{
    return a + b * cos(3.14159 * 2.0 * (c * t + d));
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float b = 0.3 * color.x + 0.59 * color.y + 0.11 * color.z;
    float ed = clamp(dot(f_cameraPos, f_normal), 0.0, 1.0);

    vec3 ca = vec3(0.5, 0.5, 0.5);
    vec3 cb = vec3(0.5, 0.5, 0.5);
    vec3 cc = vec3(1.0, 1.0, 1.0);
    vec3 cd = vec3(0.0, 0.333, 0.667);

    vec3 pal = palette(mod(b + ed, 1.0), ca, cb, cc, cd);
    color = vec4(pal, 1.0);

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}