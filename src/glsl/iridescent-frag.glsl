#define M_PI 3.1415926535897932384626433832795

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
varying vec3 e_position;

float cosine(float a, float b, float c, float d, float t) {
	return a + b * cos(2.0 * M_PI * (c * t + d));
}

void main() {
	float d = clamp(dot(f_normal, normalize(e_position - f_position)), 0.0, 1.0);
	float r = cosine(0.5, 0.5, 1.0, 0.0, d);
	float g = cosine(0.5, 0.5, 1.0, 0.33, d);
	float b = cosine(0.5, 0.5, 1.0, 0.67, d); 
    vec4 color = vec4(r, g, b, 1.0);

    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}