
uniform sampler2D tDiffuse;
uniform sampler2D tClone;
uniform float u_amount;
varying vec2 f_uv; // texture coordinate
varying vec3 f_position;

// Isolate the bright moments of the image
void main() {
    
    vec4 brightcol = texture2D(tDiffuse, f_uv);
    vec4 origcol = texture2D(tClone, f_uv);
    
    gl_FragColor = vec4(origcol.rgb + brightcol.rgb, 1.0) ;
}