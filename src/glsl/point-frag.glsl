
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

float noise(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

	float totalNoise = noise(vec2(f_position.x / 5.0, f_position.y / 5.0)); 

	if (totalNoise > 0.5) {
		gl_FragColor = vec4(0.0,0.0,0.0,1.0); 
		// gl_FragColor = vec4(0.294, 0.290, 0.282,1.0);
	} else {
	    vec4 col = texture2D(texture, f_uv);
	    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

	    // col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

	    gl_FragColor = col;	
	}

    // gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
    // gl_FragColor = vec4(0.5, 0.5, 0.0, 1.0);
}