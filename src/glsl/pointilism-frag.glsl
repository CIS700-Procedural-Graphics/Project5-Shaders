
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    float brightness = 0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b;
    //linear interpolate probability
    float probability = 0.0 * brightness + 1.0 * brightness;
    float seed = rand(vec2(f_position.x, f_position.y));
    if (seed < probability*u_amount) {
    	col.rgb = vec3(1, 1, 1);
    }
    else {
    	col.rgb = vec3(0, 0, 0);
    }

    gl_FragColor = col;
}   