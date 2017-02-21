
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float u_aspectx;
uniform float u_aspecty;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

// USING STRUCTURE TO CREATE A 5*5 MATRIX AS 2D ARRAYS ARE NOT ALLOWED IN WEBGL
struct kernel
{
    float c[5];
};

vec4 filter(in vec2 uv, in int n) // KERNEL OF N*N AROUND POINT X,Y
{
    vec4 col;
    kernel r[5];

    // SETTING UP THE GAUSSIAN KERNEL. NOTE: THE TOTAL IS 273 SO, DIVIDE BY 273 AFTER COMPUTING THE AVERAGE..
    r[0].c[0] = 1.0;   r[0].c[1] = 4.0;   r[0].c[2] = 7.0;    r[0].c[3] = 4.0;   r[0].c[4] = 1.0;
    r[1].c[0] = 4.0;   r[1].c[1] = 16.0;  r[1].c[2] = 26.0;   r[1].c[3] = 16.0;  r[1].c[4] = 4.0;
    r[2].c[0] = 7.0;   r[2].c[1] = 26.0;  r[2].c[2] = 41.0;   r[2].c[3] = 26.0;  r[2].c[4] = 7.0;
    r[3].c[0] = 4.0;   r[3].c[1] = 16.0;  r[3].c[2] = 26.0;   r[3].c[3] = 16.0;  r[3].c[4] = 4.0;
    r[4].c[0] = 1.0;   r[4].c[1] = 4.0;   r[4].c[2] = 7.0;    r[4].c[3] = 4.0;   r[4].c[4] = 1.0;

    // CONVOLUTION
    for(int i=0; i<5; i++)
    {
        for(int j=0; j<5; j++)
        {
            vec2 uvnew = vec2(uv.x + float(i-n/2)/u_aspectx, uv.y + float(j-n/2)/u_aspecty);
            col += r[i].c[j] / 273.0 * texture2D(tDiffuse, uvnew);
        }
    }

    // GET DETAILS BY SUBTRACTING THE BLURRED IMAGE FROM THE ORIGINAL IMAGE.
    // THEN ADD THOSE DETAILS TO THE ORIGINAL TO GET A SHARPENED IMAGE.
    // I.E. ORIGINAL + (ORIGINAL-BLUR) * u_amount
    
    vec4 sharp = texture2D(tDiffuse, uv) + (texture2D(tDiffuse, uv)-col)*u_amount;

    return sharp;
}

void main() {
    vec4 col = filter(f_uv,5);
    gl_FragColor = col;
}
