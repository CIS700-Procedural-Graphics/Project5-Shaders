//Referenced: https://learnopengl.com/#!Advanced-Lighting/Bloom

uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float brightThresh;
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

    vec4 brightnessComp = vec4(0.2126, 0.7152, 0.0722, 0.0);

    vec4 result = col*weights[0];
    for(int i = 1; i < 5; i++)
    {
    	vec4 rightCol = texture2D(tDiffuse, vec2(f_uv[0] + epsilon*float(i), f_uv[1]));
        if(dot(rightCol, brightnessComp) < brightThresh)
        {
            rightCol = vec4(0.0,0.0,0.0,1.0);
        }
        result += rightCol*weights[i];

    	vec4 leftCol = texture2D(tDiffuse, vec2(f_uv[0] - epsilon*float(i), f_uv[1]));
        if(dot(leftCol, brightnessComp) < brightThresh)
        {
            leftCol = vec4(0.0,0.0,0.0,1.0);
        }
        result += leftCol*weights[i];

    	vec4 topCol = texture2D(tDiffuse, vec2(f_uv[0], f_uv[1] + epsilon*float(i)));
        if(dot(topCol, brightnessComp) < brightThresh)
        {
            topCol = vec4(0.0,0.0,0.0,1.0);
        }
        result += topCol*weights[i];

    	vec4 botCol = texture2D(tDiffuse, vec2(f_uv[0], f_uv[1] - epsilon*float(i)));
        if(dot(botCol, brightnessComp) < brightThresh)
        {
            botCol = vec4(0.0,0.0,0.0,1.0);
        }
        result += botCol*weights[i];
    }

    result[3] = 1.0;

    gl_FragColor = result + col;
}  