
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform int time;
varying vec2 f_uv;

void main() {
	float t = float(time) / 1000.01;
	t = 10.0;
	float x = f_uv.x - 0.5;
	float y = f_uv.y - 0.5;


	float s1 = sin(x * 10.0 + t);


	float s2 = sin(10.0 * (x * sin(t / 2.0) + y * cos(t / 3.0)) + t);
	float cx = x + 0.5 * sin(t / 5.0);
	float cy = y + 0.5 * cos(t / 3.0);
	float s3 = sin(sqrt(100.0 * (cx * cx + cy * cy) + 1.0) + t);

	float n = (s1 + s2 + s3) / 3.0;
	//n = s1;


	vec2 deformed = vec2(f_uv.x, f_uv.y + n * u_amount);

    vec4 col = texture2D(tDiffuse, deformed);
    gl_FragColor = col;
}   