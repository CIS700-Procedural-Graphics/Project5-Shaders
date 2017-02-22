varying vec2 f_uv;
uniform sampler2D tDiffuse;

void main() {
	vec4 texel = texture2D(tDiffuse, f_uv);
    vec3 col = texel.rgb;

    float darkness = (0.2126*col.r + 0.7152*col.g + 0.0722*col.b);
	float sinValX = sin(f_uv.x * 1000.0);
	float sinValY = sin(f_uv.y * 1000.0);

	float hatching = darkness * sinValX * sinValY;

	gl_FragColor = vec4(hatching);
}