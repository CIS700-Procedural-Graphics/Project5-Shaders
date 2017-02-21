
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float sWidth;
uniform float sHeight;
uniform vec3 u_color;
varying vec2 f_uv;


vec2 getPixel(float x, float y) {
	return f_uv + vec2(1.0/sWidth, 1.0/sHeight) * vec2(x, y);
}
float getDistance(vec2 pixel) {
	return sqrt(pow(pixel.x - 0.5, 2.0) + pow(pixel.y - 0.5, 2.0));
}
vec4 getColor() {
	vec4 col = texture2D(tDiffuse, f_uv);
	return col;
}
vec4 lerp(vec4 c1, vec4 c2, float t) {
	return (1.0 - t)*c1 + t*c2;
}
// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
void main() {
    gl_FragColor = lerp(getColor(), u_amount*vec4(u_color, 1), clamp(getDistance(getPixel(0.0, 0.0)), 0.0, 1.0));

}   