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

varying float angle;

void main(){
	
	vec3 iridescence;
	float freq = 3.0; 
	iridescence.x = abs(cos(angle*freq + 1.0));
	iridescence.y = abs(cos(angle*freq + 2.0));
	iridescence.z = abs(cos(angle*freq + 3.0));
	iridescence *= u_albedo;
	
	vec4 color = texture2D(texture, f_uv);

	gl_FragColor = vec4(mix(iridescence, color.xyz, 0.5), 1.0);
}