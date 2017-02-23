
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

// https://photographylife.com/what-is-vignetting

vec4 colorFunc() {
	// f_uv is vec2 of vals from 0 to 1
	vec4 col = texture2D(tDiffuse, f_uv);

	vec4 whiteOut = vec4(1.0, 1.0, 1.0, 1.0);
	float distWeight = 0.0;

	// darken based on distance from 0.5 - if dist < .3 then dont affect color output
	float xDist = f_uv.x - 0.5;
	float yDist = f_uv.y - 0.5;
	float dist = sqrt(xDist*xDist + yDist*yDist);
	if (dist > 0.3) {
		// range of dist weights : (0.3, 0.5] so change to range of (0, 1] shift by -0.3 mul by 5.0
		distWeight = (dist - 0.3) * 5.0; //5.0 is from 10 to change to 2
	}

	col -= whiteOut * distWeight;

    return col;
 }

void main() {
    vec4 col = colorFunc();

    gl_FragColor = col;
}   