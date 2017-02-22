uniform sampler2D tDiffuse;
uniform sampler2D tOriginal;
uniform sampler2D tDownsampled;

varying vec2 f_uv;

uniform float averageFactor;
uniform float finalFactor;

void main() {
	vec4 original = texture2D(tOriginal, f_uv);
	vec4 blur = texture2D(tDiffuse, f_uv);
	vec4 downsampled = texture2D(tDownsampled, f_uv);


	vec4 finalColor = (blur + downsampled * 2.0);
	finalColor *= finalColor;
	finalColor += original;

	vec4 intermediateColor = (blur + downsampled * 2.0);
    gl_FragColor = mix(intermediateColor, finalColor, finalFactor);
}   