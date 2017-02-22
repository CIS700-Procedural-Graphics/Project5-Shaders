uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

uniform float u_time;
uniform float u_width;
uniform float u_height;


// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

int randomInt(int maxIndex, vec2 seed) {
	return int(floor(rand(seed) * float(maxIndex)));
}

void main() {

    const float CELL_SIZE = 150.0;
    const float SUBCELL_SIZE = CELL_SIZE * 3.0;
    
    vec2 xy = gl_FragCoord.xy / vec2(u_width * 2.0, u_height * 2.0);
    
    vec2 randomSeedForCell    = floor(xy * CELL_SIZE) / CELL_SIZE;
    vec2 randomSeedForSubcell = floor(xy * SUBCELL_SIZE) / SUBCELL_SIZE;
    float colorPickOffset = float(randomInt(10, randomSeedForCell)) * 0.1;
    
    vec4 textureColor = texture2D(tDiffuse, (floor(xy * CELL_SIZE + sin(u_time)) + colorPickOffset) / CELL_SIZE );
    
    float colorOffsetBase = rand(randomSeedForSubcell);
    
    float colorOffset = (1.0 - (colorOffsetBase * colorOffsetBase * colorOffsetBase));
    
   	gl_FragColor = textureColor;// * clamp(sin(u_time),0.0,1.0);
    if( rand(randomSeedForSubcell) < (1.0 / 3.0) ) {
    	gl_FragColor.r = gl_FragColor.r * colorOffset * clamp(sin(u_time), 0.0, 1.0);
        gl_FragColor.g = gl_FragColor.g * (1.0 / colorOffset) * clamp(sin(u_time), 0.0, 1.0);
    } else if(rand(randomSeedForCell) < (2.0 / 3.0)) {
        gl_FragColor.g = gl_FragColor.g * colorOffset * clamp(sin(u_time), 0.0, 1.0);
        gl_FragColor.b = gl_FragColor.b * (1.0 / colorOffset) * clamp(sin(u_time), 0.0, 1.0);
    } else {
        gl_FragColor.b = gl_FragColor.b * colorOffset * clamp(sin(u_time), 0.0, 1.0);
        gl_FragColor.r = gl_FragColor.r * (1.0 / colorOffset) * clamp(sin(u_time), 0.0, 1.0);
    }

}   