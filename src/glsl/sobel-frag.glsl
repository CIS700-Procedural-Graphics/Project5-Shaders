
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float sWidth;
uniform float sHeight;
varying vec2 f_uv;


vec2 getPixel(float x, float y) {
	return f_uv + vec2(1.0/sWidth, 1.0/sHeight) * vec2(x, y);
}

vec4 getGreyscaleColor(vec2 pixel) {
	vec4 col = texture2D(tDiffuse, pixel);
	float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);
	return col;
}

void main() {
	// Gets greyscale pixel from neighboring pixels
	vec4 a = getGreyscaleColor(getPixel(-1.0, -1.0));
	vec4 b = getGreyscaleColor(getPixel(0.0, -1.0));
	vec4 c = getGreyscaleColor(getPixel(1.0, -1.0));
	vec4 d = getGreyscaleColor(getPixel(-1.0, 0.0));
	vec4 e = getGreyscaleColor(getPixel(0.0, 0.0));
	vec4 f = getGreyscaleColor(getPixel(1.0, 0.0));
	vec4 g = getGreyscaleColor(getPixel(-1.0, 1.0));
	vec4 h = getGreyscaleColor(getPixel(0.0, 1.0));
	vec4 i = getGreyscaleColor(getPixel(1.0, 1.0));

	float r = sqrt(pow(-a.r - 2.0*d.r - g.r + c.r + 2.0*f.r + i.r, 2.0) 
		+ pow(a.r + 2.0*b.r + c.r - g.r -2.0*h.r - i.r, 2.0));
	float gc = sqrt(pow(-a.g - 2.0*d.g - g.g + c.g + 2.0*f.g + i.g, 2.0) 
		+ pow(a.g + 2.0*b.g + c.g - g.g -2.0*h.g - i.g, 2.0));
	float bc = sqrt(pow(-a.b - 2.0*d.b - g.b + c.b + 2.0*f.b + i.b, 2.0) 
		+ pow(a.b + 2.0*b.b + c.b - g.b -2.0*h.b - i.b, 2.0));
    gl_FragColor = vec4(r, gc, bc, 1.0);
}   