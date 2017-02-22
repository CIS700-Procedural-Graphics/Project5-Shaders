
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_cameraPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

//from lecture slides
vec3 getNewColor(float t)
{
    vec3 col1 = vec3(0.5, 0.5, 0.5);       
    vec3 col2 = vec3(0.5, 0.5, 0.5);
    vec3 col3 = vec3(1.0, 1.0, 0.5);
    vec3 col4 = vec3(0.8, 0.9, 0.3);

    return col1 + col2 * cos(6.28318 * (col3 * t + col4));
}

void main() {

    float t = clamp(dot(normalize(u_cameraPos - f_position), f_normal), 0.0, 0.9);

    vec3 iriCol = getNewColor(t);

	float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    gl_FragColor = vec4(d * iriCol * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}