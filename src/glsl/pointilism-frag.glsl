uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
float random(float a, float b, float c) {
    return fract(sin(dot(vec3(a, b, c), vec3(12.9898, 78.233, 78.233)))*43758.5453);
}

void main() {
    // Retrieve color and transform to gray scale
    vec4 col = texture2D(tDiffuse, f_uv);
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    // Scale probability with of darkness
    float prob = random(f_uv.x, f_uv.y, 1.0)*(1.0 - col.r*col.b*col.g) / 4.0; 

    // Compare probability to darkness and shade black if dark enough, white otherwise
    if (prob > col.r*col.b*col.g) {
    	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); 
    }
    else {
    	gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
       
}   