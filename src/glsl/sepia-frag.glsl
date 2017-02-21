
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 color = texture2D(tDiffuse, f_uv);

    // USING THE STANDARD SEPIA CONVERSION NUMBERS..
    vec4 col= vec4(clamp(color.r * 0.393 + color.g * 0.769 + color.b * 0.189, 0.0, 1.0)
        , clamp(color.r * 0.349 + color.g * 0.686 + color.b * 0.168, 0.0, 1.0)
        , clamp(color.r * 0.272 + color.g * 0.534 + color.b * 0.131, 0.0, 1.0)
        , color.a);

    col.rgb = col.rgb * (u_amount) + color.rgb * (1.0 - u_amount);
    gl_FragColor = col;
}
