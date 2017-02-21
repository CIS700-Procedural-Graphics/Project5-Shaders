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

    float rFrac = (1.0-col[0]);
    float gFrac = (1.0-col[1]);
    float bFrac = (1.0-col[2]);
    float avg = (rFrac + gFrac + bFrac)/3.0;

    float rando = abs(findNoise(pos[0], pos[1], pos[2]));

    if(rando < avg*darkness)
    {
    	if(blackWhite == 1)
    	{
   			col.rgb = vec3(0.0,0.0,0.0);
    	}
    }
    else
    {
    	col.rgb = vec3(1.0,1.0,1.0);
    }

    gl_FragColor = col;
}  