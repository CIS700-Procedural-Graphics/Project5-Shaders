
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


void main() {
    vec4 final_col = texture2D(tDiffuse, f_uv);
    //float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    //col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    final_col.x = clamp((final_col.x * 0.393) + (final_col.y *.769) + (final_col.z * .189), 0.0, 1.0);
    final_col.y = clamp((final_col.x * 0.349) + (final_col.y *.686) + (final_col.z * .168), 0.0, 1.0);
    final_col.z = clamp((final_col.x * 0.272) + (final_col.y *.534) + (final_col.z * .131), 0.0, 1.0);
    final_col.w = 1.0;
    
    gl_FragColor = final_col;
}   