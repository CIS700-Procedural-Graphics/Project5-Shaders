
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

uniform vec3 u_camPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

varying vec3 look;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    vec3 look = -normalize(f_position - u_camPos);
    if (clamp(dot(f_normal, look), 0.0, 1.0) < 0.4) {
    	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
	    d = floor(d * 10.0) * 0.1; // 10 Bins		
	    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
    }
}