
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

vec4 colorFunc() {
	vec4 color = texture2D(tDiffuse, f_uv);
	vec4 colRet = vec4(1.0, 1.0, 1.0, 1.0) - color;

  	return vec4(colRet.rgb, 1.0);
}

void main() {
    gl_FragColor = colorFunc();
}   