
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

void main() {
	float toon;
	vec4 color = vec4(u_albedo, 1.0);

	vec3 lookVector = normalize(f_position - cameraPosition);
	float dotProd = dot(lookVector, f_normal);
	if ( dotProd >= -0.4 && dotProd <= 0.4) {
		toon = 0.0;
	}
	else {
	    
	    if (u_useTexture == 1) {
	        color = texture2D(texture, f_uv);
	    }

	    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
	    toon = clamp( ( (floor(d * 3.0) + 0.5) / 3.0) , 0.0, 1.0);
    }

    gl_FragColor = vec4(toon * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}