
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv; // texture coordinate
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
// References: https://en.wikipedia.org/wiki/Gaussian_blur
//             http://dev.theomader.com/gaussian-kernel-calculator/
//             https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5

// Cannot create an array in glsl?
// const float weight[4] = {float[4](}0.383103, 0.241843, 0.060626, 0.00598};

void main() {

    vec4 col = texture2D(tDiffuse, f_uv);


    gl_FragColor = col;
}