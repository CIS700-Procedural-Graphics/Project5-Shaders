uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float sWidth;
uniform float sHeight;
varying vec2 f_uv;


// Get the pixel in uv coordinates using an offset from the current position
vec2 getPixel(float x, float y) {
	return f_uv + vec2(1.0/sWidth, 1.0/sHeight) * vec2(x, y);
}

// Retrieves the color from the texture
vec4 getColor(vec2 pixel) {
	vec4 col = texture2D(tDiffuse, pixel);
	return col;
}

void main() {
	// Get colors for each pixel
	vec4 a = getColor(getPixel(-1.0, -1.0));
	vec4 b = getColor(getPixel(0.0, -1.0));
	vec4 c = getColor(getPixel(1.0, -1.0));
	vec4 d = getColor(getPixel(-1.0, 0.0));
	vec4 e = getColor(getPixel(0.0, 0.0));
	vec4 f = getColor(getPixel(1.0, 0.0));
	vec4 g = getColor(getPixel(-1.0, 1.0));
	vec4 h = getColor(getPixel(0.0, 1.0));
	vec4 i = getColor(getPixel(1.0, 1.0));

	// Apply weighted average
	gl_FragColor = 0.1107* (a + c + g + i) + 0.1113* (b + d + h + f) + 0.1119 * e;
}   