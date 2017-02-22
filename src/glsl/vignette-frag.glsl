
uniform sampler2D tDiffuse;
uniform float u_offset;
uniform float u_darkness;
varying vec2 f_uv;

// uses 
void main() {
    vec4 texel = texture2D(tDiffuse, f_uv);
	vec2 uv = (f_uv - vec2(0.5)) * vec2(u_offset);
	gl_FragColor = vec4(mix(texel.rgb, vec3(1.0 - u_darkness), dot(uv, uv)), texel.a);
}