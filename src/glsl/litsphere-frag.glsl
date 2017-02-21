
uniform sampler2D texture;
uniform vec3 u_ambient;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

varying vec3 f_normal;
varying vec3 e_position;

void main() {
	vec3 ref = reflect(e_position, f_normal);
	float m = 2.0 * sqrt(pow(ref.x, 2.0) + pow(ref.y, 2.0) + pow(ref.z + 1.0, 2.0));
    float x = f_normal.x/m + 0.5;
    float y = f_normal.y/m + 0.5;

    vec4 color = texture2D(texture, vec2(x,y));

    gl_FragColor = vec4(color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}