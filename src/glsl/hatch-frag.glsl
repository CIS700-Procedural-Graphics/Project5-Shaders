
uniform sampler2D tDiffuse;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

bool nearlyEqual(vec3 a, vec3 b){
	return distance(a,b) < 0.01;
}

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    vec3 background = vec3(153.0,153.0,153.0)/255.0;
    vec3 white = vec3(1.0,1.0,1.0);
    vec3 black = vec3(0.0,0.0,0.0);
    float hatchVal = 1.0;
    float lightness = length(col.rgb);
    float jitter = rand(f_uv);
    vec4 red = vec4(1.0,0.5,0.5,1.0);
    
    float hatchA = sin((f_uv.x + f_uv.y) * 800.0) ;
    float hatchB = sin((f_uv.x - f_uv.y) * 800.0) ;

    if (col.rgb == background || col.rgb == white){ //don't change background or white colors
    	gl_FragColor = col;
    	return;
    }else if (hatchA > 0.6){ //if it's not in the hatch, make it white
    	
    	hatchVal = lightness/1.5;
      	col = vec4(hatchVal,0.0,0.0,1.0);
      	gl_FragColor = col;
    	// return;
    }else if(hatchB > 0.9){

    	hatchVal = lightness/1.0;
      	col = vec4(hatchVal,0.0,0.0,1.0);
      	gl_FragColor = col;
    	// return;
    }
    else{ //if it is in the hatch
		gl_FragColor = vec4(white,1.0);

    }

    //gl_FragColor = col;
}