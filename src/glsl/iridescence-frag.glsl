
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform float u_numSteps;
uniform int u_doEdge;
//uniform vec3 u_RGBamp;
//uniform vec3 u_RGBfrq;
//uniform vec3 u_RGBphz;

uniform vec3 u_irrStartCol;
uniform vec3 u_irrEndCol;
uniform float u_irrThreshold;
uniform float u_irrRampExp;
uniform int u_irrWhiteOnly;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

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

vec3 getIrrColor( float angleDot ){
	//At a given threshold angle (dot value), color appears
	// and cycle over a range of hues
	//Saturation is 0 for white/grey
	//Value is brightness so 100 for white
	
	vec3 startHSV = rgb2hsv( u_irrStartCol );
	vec3 endHSV = rgb2hsv( u_irrEndCol );
	
	if( angleDot > u_irrThreshold ){
		//calculate irridescence component		
		float t = ( angleDot - u_irrThreshold ) / ( 1.0 - u_irrThreshold );
		t = pow( t, u_irrRampExp );
		vec3 hsv;
		//lerp over hue range
		hsv[0] = (1.0 - t) * startHSV[0] + t * endHSV[0];
		//saturation
		hsv[1] = (1.0 - t) * startHSV[1] + t * endHSV[1];
		//value
		hsv[2] = (1.0 - t) * startHSV[2] + t * endHSV[2];

		return hsv2rgb(hsv);
	}
	
	return vec3(1.0, 1.0, 1.0);
}

//Color from RGB cosine func.
//Actually this doesn't work well because the color cycles and then straight-on and obtuse
// angles look the same
/*
vec3 RGBCosColor( float angleDot ){
	vec3 off = vec3( 1.0, 1.0, 1.0 ); //1.0 offset to keep color positive-valued, then div by 2 below
	//vec3 amp = vec3( 1.0, 1.0, 1.0 );
	//vec3 frq = vec3( 1.0, 1.0, 1.0 );
	//vec3 phz = vec3( 0.0, 0.0, 0.0 );
	
	vec3 color;
	for( int c = 0; c < 3; c++ ){
		color[c] = off[c] + u_RGBamp[c] * cos( 6.2831 * ( ( u_RGBfrq[c] * angleDot ) + u_RGBphz[c] ) );
		color[c] /= 2.0;
	}
	return color;
	
}
*/

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

	float angleDot = dot( normalize( cameraPosition - f_position ), f_normal );
	
	//vec3 color3 = irrColor( angleDot );
	vec3 irrColor3 = getIrrColor( angleDot );
	
	vec3 finalColor3;
	if( u_irrWhiteOnly == 1 ){
		//Apply irridescence only to white portions of the texture/object
		vec3 texHsv = rgb2hsv( color.rgb );
		if( texHsv[1] < 0.08 )
			finalColor3 = irrColor3;
		else
			finalColor3 = color.rgb;
	}else
		finalColor3 = irrColor3;
	
    gl_FragColor = vec4(d * finalColor3 * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}