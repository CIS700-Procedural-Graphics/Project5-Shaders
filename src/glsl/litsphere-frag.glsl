
uniform sampler2D image;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform float u_numSteps;
uniform int u_doEdge;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;


void main() {
	vec2 uvProj;
	uvProj[0] = (f_normal.x + 1.0) / 2.0;
	uvProj[1] = (f_normal.y + 1.0) / 2.0;
	
	vec4 color = texture2D(image, uvProj);
	gl_FragColor = color;
	
    //float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    //gl_FragColor = vec4((1.0-d) * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}