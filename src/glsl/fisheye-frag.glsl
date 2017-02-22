
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


float powinout( float power, float t ){
	power = max( power, 1.0 );
	t = clamp( t, 0.0, 1.0 );
	if( t <= 0.5 )
		return pow( t*2.0, power ) / 2.0;
	return 0.5 + pow( (t - 0.5 )*2.0, 1.0 / power ) / 2.0;
}

vec3 lerp( vec3 a, vec3 b, float t ){
	vec3 res;
	for( int i=0; i < 3; i++)
		res[i] = (1.0 - t) * a[i] + t * b[i];
	return res;
}

// DOH
// This isn't working. Isn't it even necessary? Shouldn't texture2D be
// doing interpolation anyway? But doesn't look like it, given how
// jagged the fisheye output is.
vec3 texBlerp( vec2 uv ){
	float inc = 0.00005;
	vec3 c00 = texture2D(tDiffuse, vec2( uv[0], uv[1] ) ).rgb;
	vec3 c10 = texture2D(tDiffuse, vec2( min( 1.0, uv[0] + inc) ), uv[1] ).rgb;
	vec3 c01 = texture2D(tDiffuse, vec2( uv[0], min(1.0, uv[1] + inc ) ) ).rgb;
	vec3 c11 = texture2D(tDiffuse, vec2( min( 1.0, uv[0] + inc ), min( 1.0, uv[1] + inc ) ) ).rgb;
	
	vec3 v0 = lerp(c00, c10, fract(uv[0]) );
	vec3 v1 = lerp(c01, c11, fract(uv[0]) );
	
	return lerp( v0, v1, fract(uv[1]) );
}

void main() {
	vec2 newUV = f_uv * 2.0 - 1.0;
	float dist = length(newUV);
	float newDist = 1.0 - sqrt( 1.0 - dist * dist );
	float scale = 1.0 + ( ( newDist / dist ) - 1.0 ) * u_amount;
	newUV = newUV * scale;
	//newUV = newUV * ( newDist / dist );
	newUV = (newUV + 1.0 ) / 2.0;
	
    vec4 col = texture2D(tDiffuse, newUV);
	//vec3 col3 = texBlerp( newUV );
	
    gl_FragColor = col; //vec4( col3, 1.0 );
}   