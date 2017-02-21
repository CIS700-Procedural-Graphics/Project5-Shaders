
uniform sampler2D texture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;
varying vec3 e_position;

void main() {
	vec3 eye = normalize(e_position - f_position);
	vec3 n = f_normal - dot(eye, f_normal) * eye;
	vec3 b = cross(n, vec3(0.0,1.0,0.0));
	vec3 t = cross(n, b);
    float x = (f_normal.x + 1.0)/2.0;
    float y = (f_normal.y + 1.0)/2.0;

    gl_FragColor = texture2D(texture, vec2(x,y));
}