
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

uniform vec2 resolution;
//==================================== BEGIN FUNCTIONS ====================================

float randomNoise(float x, float y)
{
    vec2 a = vec2(x, y);
    //vec2 b = vec3(12.9898, 78.233, 140.394);
    vec2 b = vec2(12.9898, 78.233);

    float dot_prod = dot(a, b);
    float val = sin(dot_prod) * 43758.5453;

    //this is essentially fract
    // float int_val = floor(val);
    // return (val - int_val) * 2.0 - 1.0;
    return fract(val);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

int randomInt(int maxIndex, vec2 seed) {
	return int(floor(rand(seed) * float(maxIndex)));
}


void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    //test random noise
    // float rand_result = randomNoise(f_uv[0], f_uv[1]);
    // gl_FragColor = vec4( vec3(rand_result, rand_result, rand_result) , 1.0  );

    const float CELL_SIZE = 150.0;
    const float SUBCELL_SIZE = CELL_SIZE * 3.0;

    vec2 xy = (gl_FragCoord.xy / resolution.xy) / 2.0;

    vec2 randomSeedForCell    = floor(xy * CELL_SIZE) / CELL_SIZE;
    vec2 randomSeedForSubcell = floor(xy * SUBCELL_SIZE) / SUBCELL_SIZE;
    float colorPickOffset = float(randomInt(10, randomSeedForCell)) * 0.1;

    vec4 textureColor = texture2D(tDiffuse, (floor(xy * CELL_SIZE) + colorPickOffset) / CELL_SIZE );

    float colorOffsetBase = rand(randomSeedForSubcell);

    float colorOffset = (1.0 - (colorOffsetBase * colorOffsetBase * colorOffsetBase));

    gl_FragColor = textureColor;
    if( rand(randomSeedForSubcell) < (1.0 / 3.0) ) {
        gl_FragColor.r = gl_FragColor.r * colorOffset;
        gl_FragColor.g = gl_FragColor.g * (1.0 / colorOffset);
    } else if(rand(randomSeedForCell) < (2.0 / 3.0)) {
        gl_FragColor.g = gl_FragColor.g * colorOffset;
        gl_FragColor.b = gl_FragColor.b * (1.0 / colorOffset);
    } else {
        gl_FragColor.b = gl_FragColor.b * colorOffset;
        gl_FragColor.r = gl_FragColor.r * (1.0 / colorOffset);
    }


    //output final frag color here
    //gl_FragColor = vec4(  col.rgb , 1.0  );

}//end main
