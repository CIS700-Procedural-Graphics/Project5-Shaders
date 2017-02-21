
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv; // texture coordinate
varying vec3 f_position;

// Isolate the bright moments of the image
void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    gl_FragColor = (1.0 - step(gray, u_amount)) * col;
}