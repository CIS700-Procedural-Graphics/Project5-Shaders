
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float line_density;
uniform float line_thickness;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


void main() {
	vec4 col = texture2D(tDiffuse, f_uv);
	float darkness = col.r + col.g + col.b;

	float hatch = sin((f_uv[0] + f_uv[1]) * line_density);
	hatch = hatch * 0.5 + 0.5;

	hatch = hatch * darkness +  darkness / 3.0 - (1.0 / (darkness + 0.001)) * line_thickness ;
	col.rgb = vec3(hatch, hatch, hatch);

    gl_FragColor = col;
}   
