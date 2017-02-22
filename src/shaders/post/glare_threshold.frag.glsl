uniform sampler2D tDiffuse;

varying vec2 f_uv;

void main() {
	vec4 color = texture2D(tDiffuse, f_uv);
	color.rgb *= color.rgb * color.a;
	color.a = 1.0;// After first round, we dont care about alpha
    gl_FragColor = color;
}   