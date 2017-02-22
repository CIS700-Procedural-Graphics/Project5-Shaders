
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float window_width;
uniform float window_height;
varying vec2 f_uv;
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

float gaussianWeight(float x, float y) {
    return 1.0/(2.0*3.14159265*1.5*1.5) * pow(2.71828, -(x*x + y*y)/(2.0*1.5*1.5));
}

void main() {
    
    float sampleSize = (3.0 + 2.0*u_amount);

    float totalWeight = 0.0;
    for (float i = 0.0; i < 600.0; i++) {
        if (i < sampleSize*sampleSize) {
            totalWeight += gaussianWeight( mod(i,sampleSize)-floor(sampleSize/2.0), floor(i/sampleSize)-floor(sampleSize/2.0) );
        }
        else {
            break;
        }
    }

    vec4 color = vec4(0.0);
    for (float i = 0.0; i < 600.0; i++) {
        if (i < sampleSize*sampleSize) {
            color += gaussianWeight( mod(i,sampleSize)-floor(sampleSize/2.0), floor(i/sampleSize)-floor(sampleSize/2.0) ) / totalWeight * 
                    texture2D(tDiffuse, vec2( 
                        f_uv.x + (mod(i,sampleSize)-floor(sampleSize/2.0)) *1.0/window_width, 
                        f_uv.y + (floor(i/sampleSize)-floor(sampleSize/2.0)) *1.0/window_height ) );
        }
        else {
            break;
        }
    }

    gl_FragColor = vec4(color.r, color.g, color.b, 1.0);
}   