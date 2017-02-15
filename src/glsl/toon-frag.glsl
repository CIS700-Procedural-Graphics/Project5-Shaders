
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

// put into buckets 
float findDiscreteValue() {
	float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0) * 5.0;
	if (d <= 1.0) {
		return 0.0;
	} else if (d <= 2.0) {
		return 1.0;
	} else if (d <= 3.0) {
		return 2.0;
	} else if (d <= 4.0) {
		return 3.0;
	} else {
		return 4.0;
	}
}

void main() {
	vec3 cameraLook = f_position - cameraPosition; 
	if (dot(cameraLook, f_normal) <= 0.5 && dot(cameraLook, f_normal) >= -0.5) {
		gl_FragColor = vec4(1.0,1.0,1.0,1.0);
	}
	else {
	    vec4 color = vec4(u_albedo, 1.0);
	    
	    if (u_useTexture == 1) {
	        color = texture2D(texture, f_uv);
	    }

	    // float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

	    float toonValue = findDiscreteValue() / 5.0; 
	    // take dot, multiplly by 10, then mod it by 10, then use that value to 

	    gl_FragColor = vec4(toonValue * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);

	}

}