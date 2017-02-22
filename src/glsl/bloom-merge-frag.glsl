
uniform sampler2D tDiffuse;
uniform sampler2D tOriginal;
varying vec2 f_uv;
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    
    vec4 originalColor = texture2D(tOriginal, f_uv);
    
    vec4 gaussianColor = texture2D(tDiffuse, f_uv);

    vec4 color = originalColor + gaussianColor;

    gl_FragColor = vec4(color.r, color.g, color.b, 1.0);
}   