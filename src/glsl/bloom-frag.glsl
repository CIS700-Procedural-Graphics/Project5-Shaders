
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float u_radius; // Radius of blur
uniform float u_width;
uniform float u_height;
uniform vec2 u_dir; // Direction of blur
varying vec2 f_uv; // texture coordinate
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
// Sigma: 1.0
// Kernel Size 7
// References: https://en.wikipedia.org/wiki/Gaussian_blur
//             http://dev.theomader.com/gaussian-kernel-calculator/
//             https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5

// Cannot create an array in glsl?
// const float weight[4] = {float[4](}0.383103, 0.241843, 0.060626, 0.00598};

void main() {

    vec4 col = texture2D(tDiffuse, f_uv);
    float blur = u_radius / (u_width * u_height);
	vec4 sum = vec4(0.0); // Sum of the color

	// TODO: is anything added if coord out of bounds? 
	//       I would expect it would add nothing or error
	// vec4 texture2D(sampler2D sampler, vec2 coord, float bias)
	sum += texture2D(tDiffuse, vec2(f_uv.x - 4.0 * blur * u_dir.x, f_uv.y - 4.0 * blur * u_dir.y)) * 0.0162162162;
	sum += texture2D(tDiffuse, vec2(f_uv.x + 4.0 * blur * u_dir.x, f_uv.y + 4.0 * blur * u_dir.y)) * 0.0162162162;

	sum += texture2D(tDiffuse, vec2(f_uv.x - 3.0 * blur * u_dir.x, f_uv.y - 3.0 * blur * u_dir.y)) * 0.0540540541;
	sum += texture2D(tDiffuse, vec2(f_uv.x + 3.0 * blur * u_dir.x, f_uv.y + 3.0 * blur * u_dir.y)) * 0.0540540541;

	sum += texture2D(tDiffuse, vec2(f_uv.x - 2.0 * blur * u_dir.x, f_uv.y - 2.0 * blur * u_dir.y)) * 0.1216216216;
	sum += texture2D(tDiffuse, vec2(f_uv.x + 2.0 * blur * u_dir.x, f_uv.y + 2.0 * blur * u_dir.y)) * 0.1216216216;

	sum += texture2D(tDiffuse, vec2(f_uv.x - 1.0 * blur * u_dir.x, f_uv.y - 1.0 * blur * u_dir.y)) * 0.1945945946;
	sum += texture2D(tDiffuse, vec2(f_uv.x + 1.0 * blur * u_dir.x, f_uv.y + 1.0 * blur * u_dir.y)) * 0.1945945946;

	sum += texture2D(tDiffuse, vec2(f_uv.x, f_uv.y)) * 0.2270270270;

    gl_FragColor = vec4(sum.rgb, 1.0);
}   