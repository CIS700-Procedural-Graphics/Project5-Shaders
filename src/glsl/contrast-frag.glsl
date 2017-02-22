
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
 

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 dummy(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float powinout( float power, float t ){
	power = max( power, 1.0 );
	t = clamp( t, 0.0, 1.0 );
	if( t <= 0.5 )
		return pow( t*2.0, power ) / 2.0;
	return 0.5 + pow( (t - 0.5 )*2.0, 1.0 / power ) / 2.0;
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
	
    //float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    //col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

	vec3 hsv = rgb2hsv( col.rgb );
	hsv.z = powinout( u_amount * 10.0 + 1.0, hsv.z );
	//NOTE for some bizarre reason, when call hsv2rgb() here instead of dummy(), get an error
	col.rgb = dummy( hsv );

    gl_FragColor = col;
}   