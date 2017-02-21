
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

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

	vec3 look = normalize(f_position - u_cameraPos);
	if (dot(f_normal, look) > -0.2 && dot(f_normal, look) < 0.2) {
		gl_FragColor == vec4(0.0,0.0,0.0,1.0);
	} else {
		if (mod(color.x, 0.3) != 0.0) {
		    if (mod(color.x, 0.3) >= 0.05) {
		    	color.x = color.x + (0.3 - mod(color.x, 0.3)); 
		    } else if (mod(color.x, 0.3) < 0.05) {
		    	color.x = color.x - (mod(color.x, 0.3));
		    }
	    }

	    if (mod(color.y, 0.3) != 0.0) {
			if (mod(color.y, 0.3) >= 0.05) {
		    	color.y = color.y + (0.3 - mod(color.y, 0.3)); 
		    } else if (mod(color.y, 0.3) < 0.05) {
		    	color.y = color.y - (mod(color.y, 0.3));
		    }
		}

		if (mod(color.z, 0.3) != 0.0) {
			if (mod(color.z, 0.3) >= 0.05) {
		    	color.z = color.z + (0.3 - mod(color.z, 0.3)); 
		    } else if (mod(color.z, 0.3) < 0.05) {
		    	color.z = color.z - (mod(color.z, 0.3));
		    }
		}
		gl_FragColor = vec4(color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
	}
}