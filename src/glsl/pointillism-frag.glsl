
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

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    //test random noise
    // float rand_result = randomNoise(f_uv[0], f_uv[1]);
    // gl_FragColor = vec4( vec3(rand_result, rand_result, rand_result) , 1.0  );

    const float sizepercell = 150.0;
    const float sizepersubcell = sizepercell * 5.0;

    //scale the image properly. similar to vignette
    vec2 scaled_xy = (gl_FragCoord.xy / resolution.xy) / 2.0;

    //break down texture into cell size offsets
    vec2 scaledCell    = floor(f_uv * sizepercell) / sizepercell;
    vec2 scaledsubcell = floor(f_uv * sizepersubcell) / sizepersubcell;

    float noiseoffsetCell = randomNoise(scaledCell.x, scaledCell.y);
    float noiseoffsetSubCell = randomNoise(scaledsubcell.x, scaledsubcell.y);
    float colorOffset = (1.0 - (noiseoffsetSubCell * noiseoffsetSubCell * noiseoffsetSubCell));

    //recalculate the color with new scaled pixel offsets
    vec4 textureColor = texture2D(tDiffuse, (floor(scaled_xy * sizepercell) + noiseoffsetCell) / sizepercell );
    gl_FragColor = textureColor;

    //offset color based on some random criteria
    //set
    if( noiseoffsetSubCell < (1.0 / 3.0) )
    {
        gl_FragColor.r = gl_FragColor.r * colorOffset;
        gl_FragColor.g = gl_FragColor.g * (1.0 / colorOffset);
    }
    else if(noiseoffsetSubCell < (2.0 / 3.0))
    {
        gl_FragColor.g = gl_FragColor.g * colorOffset;
        gl_FragColor.b = gl_FragColor.b * (1.0 / colorOffset);
    }
    else
    {
        gl_FragColor.b = gl_FragColor.b * colorOffset;
        gl_FragColor.r = gl_FragColor.r * (1.0 / colorOffset);
    }


}//end main
