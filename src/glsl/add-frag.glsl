uniform sampler2D tDiffuse;
uniform sampler2D tOther;
varying vec2 f_uv;

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
	vec4 bloom = texture2D(tOther, f_uv);

    gl_FragColor = vec4(col.rgb + bloom.rgb, 1.0);
}   