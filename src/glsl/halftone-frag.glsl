
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float noise_amount;
uniform float color_amount;
uniform float aspect_ratio;
varying vec2 f_uv;

 
float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

void main() {

	vec4 col = texture2D(tDiffuse, f_uv);
	vec2 uv = f_uv;
	uv.y /= aspect_ratio;
	mat2 rot45 = mat2(0.707, -0.707, 0.707, 0.707); // rotate 45
	uv = rot45 * uv;
    vec2 mapped_uv = 2.0 * fract(100.0 * u_amount * uv) - 1.0; // map uvs to -1 to 1
	
	float noise = 0.1*rand(f_uv) * noise_amount; // noise
    float radius = sqrt(1.0-col.g); // Change the radius size using the green component of the color
    vec3 final_col = mix(vec3(0.0), vec3(1.0), step(radius,length(mapped_uv)+noise));
    gl_FragColor = vec4(final_col + col.rgb * color_amount, 1.0);

}