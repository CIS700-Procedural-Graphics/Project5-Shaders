
uniform sampler2D tDiffuse;
uniform float contrast;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float bias(float b, float t) {
	return pow(t, log(b)/log(0.5));
}

float gain(float g, float t) {
	if (t < 0.5) return bias(1.0-g, 2.0*t)/2.0;
	else return 1.0 - bias(1.0-g, 2.0 - 2.0*t)/2.0;
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    col.r = gain(contrast, col.r);
    col.g = gain(contrast, col.g);
    col.b = gain(contrast, col.b);

    gl_FragColor = col;
}   