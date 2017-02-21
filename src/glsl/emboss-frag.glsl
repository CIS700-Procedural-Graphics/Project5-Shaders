//Referenced: http://setosa.io/ev/image-kernels/ for matrix operation

uniform sampler2D tDiffuse;
varying vec2 f_uv;

uniform float radius;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    //epsilon represents the distance away from our original texture coordinate that we sample the new texture points from
    float epsilon = 0.001*radius;

    //sampling all the surrounding points on this texture within epsilon in the negative and positive u and v directions
    vec4 upLeft = texture2D(tDiffuse, vec2(f_uv[0] - epsilon, f_uv[1] + epsilon));
    vec4 upMid = texture2D(tDiffuse, vec2(f_uv[0], f_uv[1] + epsilon));
    vec4 upRight = texture2D(tDiffuse, vec2(f_uv[0] + epsilon, f_uv[1] + epsilon));
    vec4 midLeft = texture2D(tDiffuse, vec2(f_uv[0] - epsilon, f_uv[1]));
    vec4 midRight = texture2D(tDiffuse, vec2(f_uv[0] + epsilon, f_uv[1]));
    vec4 lowLeft = texture2D(tDiffuse, vec2(f_uv[0] - epsilon, f_uv[1] - epsilon));
    vec4 lowMid = texture2D(tDiffuse, vec2(f_uv[0], f_uv[1] - epsilon));
    vec4 lowRight = texture2D(tDiffuse, vec2(f_uv[0] + epsilon, f_uv[1] - epsilon));

    //apply convolution with kernel found on site cited above to these samples to get result
    col = col + -2.0*upLeft + -1.0*upMid + -1.0*midLeft + 1.0*midRight + 1.0*lowMid + 2.0*lowRight;

    gl_FragColor = col;
}  