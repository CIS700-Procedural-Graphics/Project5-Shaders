uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

uniform float u_width;
uniform float u_height;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to
/*
void main()
{
    float offset[3]; 
    offset[0] = 0.0;
    offset[1] = 1.3846153846;
    offset[2] = 3.2307692308;
    float weight[3];
    weight[0] = 0.2270270270;
    weight[1] = 0.3162162162;
    weight[2] = 0.0702702703;

    vec3 tc = vec3(1.0,0.0,0.0);
    
    if(gl_FragCoord.x < (u_amount - 0.01))
    {
        vec2 uv = gl_FragCoord.xy;
        tc = texture2D(tDiffuse, f_uv).rgb * weight[0];
        for(int i = 1; i < 3; i++)
        {
            tc += texture2D(tDiffuse, f_uv + vec2(offset[i]/u_width), 0.0).rgb * weight[i];
            tc += texture2D(tDiffuse, f_uv - vec2(offset[i]/u_width), 0.0).rgb * weight[i];
        }
    }else if(gl_FragCoord.x >= (u_amount + 0.01))
    {
        tc = texture2D(tDiffuse, f_uv).rgb;
    }
    
    gl_FragColor = vec4(tc, 1.0);

}

*/

/*
float bh = 1.0 / float(u_width);
float bv = 1.0 / float(u_height);

void main() {
    vec4 final_col;

    for(int x = -1; x <= 1; x++)
    {
        for(int y = -1; y <= 1; y++)
        {
            final_col = final_col + (texture2D(tDiffuse, vec2(f_uv.x + float(x) * bh, f_uv.y + float(y) * bv)) / 9.0);
        }
    }
    
    gl_FragColor = final_col;
}   */



float gaussian(in float x, in float y, in float sigma)
{
	//return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
    return ( 1.0 / ( 2.0 * 3.141 * sigma * sigma ) ) * exp( - (x * x + y * y) / (2.0 * sigma * sigma) );
}

void main() {

        
        float kernel[9];
        float sigma = 1.5;
        float w = 0.0;
        vec4 final_col = vec4(0.0);
        
        //creating a 2D kernel
        kernel[0] = gaussian(0.0, 0.0, sigma);
        kernel[1] = gaussian(0.0, 1.0, sigma);
        kernel[2] = gaussian(0.0, 2.0, sigma);
        kernel[3] = gaussian(1.0, 0.0, sigma);
        kernel[4] = gaussian(1.0, 1.0, sigma);
        kernel[5] = gaussian(1.0, 2.0, sigma);
        kernel[6] = gaussian(2.0, 0.0, sigma);
        kernel[7] = gaussian(2.0, 1.0, sigma);
        kernel[8] = gaussian(2.0, 2.0, sigma);
      
        //finding the total weight of the kernal points
        for(int i = 0; i < 9; i++)
        {
            w += kernel[i];
        }

        //multiplying the color and the gaussian value at each point and dividing it by the total weight to keep sum = 1
        /*
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y - (1.0) / float(u_height))) * kernel[0] / w;
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y)) * kernel[1] / w;
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y + (1.0) / float(u_height))) * kernel[2] / w;
        
        final_col += texture2D(tDiffuse, vec2(f_uv.x , f_uv.y - (1.0) / float(u_height) )) * kernel[3] / w;
        final_col += texture2D(tDiffuse, vec2(f_uv.x , f_uv.y  )) * kernel[4] / w;
        final_col += texture2D(tDiffuse, vec2(f_uv.x , f_uv.y + (1.0) / float(u_height) )) * kernel[5] / w;
        
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y - (1.0) / float(u_height))) * kernel[6] / w;
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y )) * kernel[7] / w;
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y + (1.0) / float(u_height))) * kernel[8] / w;
        */
        //displaying the final color to the screen
    
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (2.0) / float(u_width), f_uv.y - (2.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (2.0) / float(u_width), f_uv.y - (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (2.0) / float(u_width), f_uv.y - (0.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (2.0) / float(u_width), f_uv.y + (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (2.0) / float(u_width), f_uv.y + (2.0) / float(u_height)));
        
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y - (2.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y - (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y - (0.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y + (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (1.0) / float(u_width), f_uv.y + (2.0) / float(u_height)));
        
        
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (0.0) / float(u_width), f_uv.y - (2.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (0.0) / float(u_width), f_uv.y - (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (0.0) / float(u_width), f_uv.y - (0.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (0.0) / float(u_width), f_uv.y + (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x - (0.0) / float(u_width), f_uv.y + (2.0) / float(u_height)));
        
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y - (2.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y - (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y - (0.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y + (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (1.0) / float(u_width), f_uv.y + (2.0) / float(u_height)));
        
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (2.0) / float(u_width), f_uv.y - (2.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (2.0) / float(u_width), f_uv.y - (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (2.0) / float(u_width), f_uv.y - (0.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (2.0) / float(u_width), f_uv.y + (1.0) / float(u_height)));
        final_col += texture2D(tDiffuse, vec2(f_uv.x + (2.0) / float(u_width), f_uv.y + (2.0) / float(u_height)));
        
        final_col = final_col / 25.0;
    
        gl_FragColor = vec4(final_col.rgb, 1.0);
    
}



/*

int count = 0;
        for(int i = -1; i <= 1; i++)
        {
            for(int j = -1; j<= 1; j++)
            {
                final_col += texture2D(tDiffuse, vec2(f_uv.x + float(i), f_uv.y + float(j))) * kernel[count] / w;
                count += 1;
            }
            count += 1;
        }
^^^^^^^^^
        //declare stuff
		const int mSize = 11;
		const int kSize = (mSize-1)/2;
		float kernel[mSize];
		vec4 final_colour = vec4(0.0);
		
		//create the 1-D kernel
		float sigma = 14.0;
		float Z = 0.0;
		for (int j = 0; j <= kSize; ++j)
		{
            float npdf_val = npdf(float(j), sigma);
			kernel[kSize+j] = npdf_val;
            kernel[kSize-j] = npdf_val;
		}
		
		//get the normalization factor (as the gaussian has been clamped)
		for (int j = 0; j < mSize; ++j)
		{
			Z += kernel[j];
		}
		
		//read out the texels
		for (int i=-kSize; i <= kSize; ++i)
		{
			for (int j=-kSize; j <= kSize; ++j)
			{
				final_colour += kernel[kSize+j]*kernel[kSize+i]*texture2D(tDiffuse, f_uv);
	
			}
		}
		
		
		gl_FragColor = vec4((final_colour.rgb/(Z*Z)), 1.0); */