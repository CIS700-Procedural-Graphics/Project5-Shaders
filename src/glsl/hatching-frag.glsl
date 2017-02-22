

uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float u_h1fx;
uniform float u_h1fy;
uniform float u_h1scale;
uniform float u_h1noise;
uniform float u_h2fx;
uniform float u_h2fy;
uniform float u_h2scale;
uniform float u_h2noise;

varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float noise_gen2(float x, float y) {
  float val = sin( dot( vec2(x,y), vec2( 12.9898, 78.233 )) ) * 43758.5453;
  return val - floor(val);
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
 
void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    //float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	vec3 hsv = rgb2hsv( col.rgb );

	float noiseMaxPhaseOffset = 1.0;
	
    //Hatching pattern, cycles smoothly black to white
    float phase = u_h1fx * f_uv[0] + u_h1fy * f_uv[1];
	float noise = noise_gen2( f_uv[0], f_uv[1] );
    phase += noise * noiseMaxPhaseOffset * u_h1noise;
    float hatch1 = ( sin( phase * 6.283 ) + 1.0 ) / 2.0; //get into range [0,1];

    float phase2 = u_h2fx * f_uv[0] - u_h2fy * f_uv[1];
	noise = noise_gen2( f_uv[1], f_uv[0] ); //flip the noise inputs
    phase2 += noise * noiseMaxPhaseOffset * u_h2noise;
    float hatch2 = ( sin( phase2 * 6.283 ) + 1.0 ) / 2.0;

    float hatch = ( ( hatch1 * u_h1scale)  + (hatch2 * u_h2scale) ) / (u_h1scale + u_h2scale);
    //float hatch = max( hatch1, hatch2 );
    
    //Scale the hatching pattern range with min set as brightness value for the fragment
    //So the darker the fragment, the darker the trough of the hatch
    //Add u_amount, scaling the overall hatch darkness
    float brightness = hsv[2];
    float scale = min( 1.0, hatch / (1.01 - brightness) + brightness + (1.0 - u_amount) );

    gl_FragColor = vec4( scale, scale, scale, 1.0 );

}