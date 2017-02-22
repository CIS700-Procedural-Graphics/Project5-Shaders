
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

float M_PI = 3.1415926535;

void main() {

// referred to http://www.geeks3d.com/20140213/glsl-shader-library-fish-eye-and-dome-and-barrel-distortion-post-processing-filters/
    
    vec2 uv = f_uv.xy;

	vec2 xy = 2.0 * f_uv.xy - 1.0;
	float d = length(xy);
	float z = sqrt(1.0 - d * d);
	float r = (1.0 - u_amount) * atan(d, z) / M_PI;
	float t = atan(xy.y, xy.x);

	uv.x = r * cos(t) + 0.5;
	uv.y = r * sin(t) + 0.5;
	

	vec4 c = texture2D(tDiffuse, uv);
	gl_FragColor = c;
}   