uniform sampler2D tDiffuse;
uniform float darkness;
uniform int blackWhite;
varying vec2 f_uv;
varying vec3 pos;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float findNoise(float x, float y, float z)
{
	vec3 v1 = vec3(x, y, z);
	vec3 v2 = vec3(12.9898, 78.233, 46.379);
	float bigNum = sin(dot(v1, v2))*43758.5453;
	if(bigNum < 0.0){ return bigNum - ceil(bigNum); }
	else { return bigNum - floor(bigNum); }
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    //values ranging 0 to 1 that serve as a weight of darkness, with 1 being darkest
    float rFrac = (1.0-col[0]);
    float gFrac = (1.0-col[1]);
    float bFrac = (1.0-col[2]);
    //average all the values to get 1 for this pixel
    float avg = (rFrac + gFrac + bFrac)/3.0;

    //need a random value to compare against the probability, found with noise
    float rando = abs(findNoise(pos[0], pos[1], pos[2]));

    //compare rando to my probability, which is enhanced by the darkness factor
    if(rando < avg*darkness)
    {
    	//if this pixel should be colored and blackWhite is on, it gets colored black, otherwise the color is left alone
        if(blackWhite == 1)
    	{
   			col.rgb = vec3(0.0,0.0,0.0);
    	}
    }
    else
    {
        //if this pixel should not be colored, its given a white color
    	col.rgb = vec3(1.0,1.0,1.0);
    }

    gl_FragColor = col;
}  