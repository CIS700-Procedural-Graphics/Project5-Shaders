
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

#define M_PI 3.1415926535897932384626433832795

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

vec4 colorFunc() {
	vec4 r = texture2D(tDiffuse, f_uv - 0.05);
	vec4 g = texture2D(tDiffuse, f_uv - 0.03);
	vec4 b = texture2D(tDiffuse, f_uv - 0.01);
  	vec4 color = vec4(r.x, g.y, b.z, 1.0);

  	return color;
}

void main() {
    gl_FragColor = colorFunc();
}   