//Referenced: https://learnopengl.com/#!Advanced-Lighting/Bloom

uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    float epsilon = 0.001*u_amount;
    float weights[5]; 
    weights[0] = 0.227027;
    weights[1] = 0.1945946/2.0;
    weights[2] = 0.1216216/2.0;
    weights[3] = 0.054054/2.0;
    weights[4] = 0.016216/2.0;

    vec4 result = col*weights[0];
    for(int i = 1; i < 5; i++)
    {
    	result += texture2D(tDiffuse, vec2(f_uv[0] + epsilon*float(i), f_uv[1]))*weights[i];
    	result += texture2D(tDiffuse, vec2(f_uv[0] - epsilon*float(i), f_uv[1]))*weights[i];
    	result += texture2D(tDiffuse, vec2(f_uv[0], f_uv[1] + epsilon*float(i)))*weights[i];
    	result += texture2D(tDiffuse, vec2(f_uv[0], f_uv[1] - epsilon*float(i)))*weights[i];
    }

    result[3] = 1.0;

    gl_FragColor = result;
}  