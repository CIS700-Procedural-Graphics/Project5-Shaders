uniform sampler2D tOriginal;
uniform sampler2D tDiffuse;

varying vec2 f_uv;

void main() {
	vec4 color = texture2D(tOriginal, f_uv);
	color.rgb *= color.rgb * color.a;
    gl_FragColor = color;
}   