uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;


void main() {

	vec4 col = texture2D(tDiffuse, f_uv);
	
	//sepia
	col = vec4(clamp(col.r * 0.393 + col.g * 0.769 + col.b * 0.189, 0.0, 1.0)
        , clamp(col.r * 0.349 + col.g * 0.686 + col.b * 0.168, 0.0, 1.0)
        , clamp(col.r * 0.272 + col.g * 0.534 + col.b * 0.131, 0.0, 1.0)
        , col.a
    );

	//vignette
	vec2 uv = (f_uv - vec2(0.5)) * 1.5 * u_amount;
	gl_FragColor = vec4(mix(col.rgb, vec3(0.0), pow(dot(uv,uv),0.8)), col.a);
}