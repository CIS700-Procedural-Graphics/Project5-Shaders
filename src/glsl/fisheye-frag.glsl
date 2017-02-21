
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

uniform float u_width;
uniform float u_height;

void main() {
    
    
/*
    vec2 uv = gl_FragCoord.xy / vec2(u_width, u_height);
    float ratio = u_width / u_height;
    float strength = sin(u_amount * 2.0) * 0.02;
    
    vec2 intensity = vec2(strength * ratio, strength * ratio);
    
    vec2 coord = uv;
    coord = (coord - 0.5) * 2.0;
    
    vec2 realCoOffset;
    realCoOffset.y = (1.0 - coord.y * coord.y) * intensity.y * (coord.x);
    realCoOffset.x = (1.0 - coord.x * coord.x) * intensity.x * (coord.y);

    vec4 col = texture2D(tDiffuse, uv - realCoOffset);
    gl_FragColor = col;


//down new
    vec2 p = gl_FragCoord.xy / vec2(u_width, u_height);
    float prop = u_width / u_height;

    vec2 center = vec2(vec2(u_amount, u_amount) / vec2(u_width, u_height));
	vec2 dist = p - center;//vector from center to current fragment
	
    float r = sqrt(dot(dist, dist)); // distance of pixel from center

    vec2 uv;
    if(r >= prop)
    {
        uv = p;
    }else
    {
        uv = center + dist * r;
    }

    vec3 col = texture2D(tDiffuse, vec2(uv.x, -uv.y)).rgb;
    gl_FragColor = vec4(col, 1.0);

//one down
	float power = ( 2.0 * 3.141592 / (2.0 * sqrt(dot(dist, dist))) ) *
				(u_amount / u_width - 0.5);//amount of effect

	float bind;//radius of 1:1 effect=
	
    if (power > 0.0) //stick to corners
        bind = sqrt(dot(center, center));
	else //stick to borders
    {
        if (prop < 1.0) 
            bind = center.x; 
        else 
            bind = center.y; 
    }

	//Weird formula
	vec2 uv = f_uv;
	if (power > 0.0)//fisheye
		uv = center + normalize(dist) * tan(r * power) * bind / tan( bind * power);
	else if (power < 0.0)//antifisheye
		uv = center + normalize(dist) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
	else uv = p;//no effect for power = 1.0

    //Second part of cheat
    //for round effect, not elliptical
	vec4 col = texture2D(tDiffuse, vec2(uv.x, -uv.y * prop));
    
    gl_FragColor = vec4(col.rgb, 1.0);*/
}   