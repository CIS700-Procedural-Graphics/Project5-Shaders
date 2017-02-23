
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

#define M_PI 3.1415926535897932384626433832795

// http://gamedev.stackexchange.com/questions/20626/how-do-i-create-a-wide-angle-fisheye-lens-with-hlsl 

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

vec4 colorFunc() {
	// f_uv is vec2 of vals from 0 to 1
	// vec4 col = texture2D(tDiffuse, f_uv);

    // return col;

	float xOffset = 0.5;
	float yOffset = 0.5;

	// setting up variables
	// ap: aperture
	float ap = 178.0;
	float max = sin((M_PI / 180.0) * 0.5 * ap);
  
  	vec2 xyLoc = 2.0 * f_uv.xy - 1.0;
  	vec2 uvLoc = vec2(0.0, 0.0);
  	float len = length(xyLoc);
  	float checkMax = 2.0 - max;
  	
  	// if in the area for the bulge then
  	if (len < checkMax) {
	    len = length(xyLoc * max);

	    float r = atan(len, sqrt(1.0 - len * len)) / M_PI;
	    float theta = atan(xyLoc.y, xyLoc.x);
	    
	    uvLoc = vec2(r * cos(theta) + xOffset, r * sin(theta) + yOffset);
	// otherwise keep original uv value
  	} else {
  	  	uvLoc = f_uv.xy;
  	}

  	return texture2D(tDiffuse, uvLoc);
}

void main() {
    gl_FragColor = colorFunc();
}   