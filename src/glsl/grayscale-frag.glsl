
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);



    //color based on uv's 
    //col.rgb = vec3(sin(f_uv[0]), cos(f_uv[1]), cos(f_uv[0]));


    //this is sepia
    /*
    col = vec4(
      clamp(col.r * 0.393 + col.g * 0.769 + col.b * 0.189, 0.0, 1.0)
    , clamp(col.r * 0.349 + col.g * 0.686 + col.b * 0.168, 0.0, 1.0)
    , clamp(col.r * 0.272 + col.g * 0.534 + col.b * 0.131, 0.0, 1.0)
    , col.a
    );
    */

    //this is weird coloring. get rid of this line to bring back grayscale
    //col = vec4(sin(col.r), cos(col.g), sin(col.b), col.a);

    gl_FragColor = col;
}
