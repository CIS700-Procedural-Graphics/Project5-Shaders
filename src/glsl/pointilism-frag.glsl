varying vec2 f_uv;
uniform sampler2D tDiffuse;

float generateNoise(float x, float y) {
    return fract(sin(dot(vec2(x,y), vec2(12.9898, 78.23))) * 43758.5453);
}

void main() {
	vec4 texel = texture2D(tDiffuse, f_uv);
    vec3 col = texel.rgb;

    float darkness = (0.2126*col.r + 0.7152*col.g + 0.0722*col.b);
    float noiseValue = generateNoise(texel.x, texel.y);
 
	if (noiseValue > darkness) {
		gl_FragColor = vec4(darkness);
	} else {
		gl_FragColor = vec4(1.0);
	}
}