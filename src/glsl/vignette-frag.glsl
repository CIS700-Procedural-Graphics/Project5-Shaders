
uniform sampler2D tDiffuse;
uniform float u_offset;
uniform float u_darkness;
varying vec2 f_uv;

void main() {

	vec4 col = texture2D(tDiffuse, f_uv);
	col.rgb *= smoothstep(0.8, u_offset / 2.0, 
		distance(f_uv, vec2(0.5)) * (u_darkness + u_offset));
	gl_FragColor = col;
}