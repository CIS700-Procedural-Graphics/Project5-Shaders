uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
	
	// Scale the UVs to change the "frequency" of the noise
	vec2 scaledUVs = f_uv * 4.0;
	
	// Sum together three sinusoid functions to imitate noise
    // These sin functions were originally taken from: http://www.bidouille.org/prog/plasma
    float s1 = sin((scaledUVs.x - 0.5) * 10.0);
    float s2 = sin(10.0 * ((scaledUVs.x - 0.5) * sin(0.5) + (scaledUVs.y - 0.5) * cos(0.333)));

    float s3X = (scaledUVs.x - 0.5) + 0.5 * sin(0.2);
    float s3Y = (scaledUVs.y - 0.5) + 0.5 * cos(0.667);
    float s3 = sin(sqrt(100.0 * (s3X * s3X + s3Y * s3Y) + 1.0));

    // Sum the sinusoid functions
    float summedSin = (s1 + s2 + s3) * u_amount * 0.333;
    
    vec2 warpedUvOffset = vec2(summedSin, summedSin);
    
    //To warp the image, offset the y-component of the uv of this quad.
    vec4 col = texture2D(tDiffuse, f_uv + warpedUvOffset);
    // vec4 col = vec4(summedSin, summedSin, summedSin, 1);
    gl_FragColor = col;
}