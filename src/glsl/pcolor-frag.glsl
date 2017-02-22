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
	float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0) * 3.0;
	if (d <= 1.0) {
		return 0.0;
	} else if (d <= 2.0) {
		return 1.0;
	} else {
		return 2.0;
	}
}

void main() {
	vec3 cameraLook = f_position - cameraPosition; 

	    vec4 color = vec4(255.0/255.0, 177.0/255.0, 163.0/255.0,1.0);

	    float toonValue = findDiscreteValue() / 3.0; 
	    if (toonValue <= 1.0) {
	    	// blue
	   	 	color = vec4(108.0/255.0, 133.0/255.0, 232.0/255.0,1.0);
	    } else if (toonValue <= 2.0) {
	    	// light blue
	    	color = vec4(158.0/255.0 + 2.0, 177.0/215.0 - 2.0, 255.0/255.0,1.0);
	    } 

	    gl_FragColor = vec4(toonValue * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);

	// }

}