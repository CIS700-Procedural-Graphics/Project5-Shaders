
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
varying vec3 fPos;

float noise(float x, float y){
	float value1 = fract(sin(dot(vec2(x, y) ,vec2(1027.9898, 29381.233))) * 333019.5453);

	return dot(value1, 14958832.22); 
}

float hatch(float x, float y) {
	return sin(300.0 * (x+y) );
}

void main() {
	float noiseValue = noise(fPos.x , fPos.y); 
	float hatching = hatch(fPos.x, fPos.y); 

	if (noiseValue < 0.5) {
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	} else if (hatching > 0.7) {
		gl_FragColor = vec4(0.294, 0.290, 0.282,1.0);
	} else {
	    vec4 col = texture2D(tDiffuse, f_uv);
	    col.rgb = vec3(0.811, 0.666, 0.466) * (0.2) + col.rgb * (1.0 - 0.2);
	    gl_FragColor = col;	
	}
    // vec4 col = texture2D(tDiffuse, f_uv);
    // float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    // col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    // gl_FragColor = col;
}   