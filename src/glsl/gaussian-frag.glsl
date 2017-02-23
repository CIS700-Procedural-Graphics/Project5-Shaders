
uniform sampler2D tDiffuse;
uniform float u_amount;
uniform float u_aspectx;
uniform float u_aspecty;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

struct kernel
{
    float c[5];
};

vec4 filter(in vec2 uv, in int n) // KERNEL OF N*N AROUND POINT X,Y
{
    vec4 col;
    kernel r[5];

    // THE KERNEL CREATION FORMULA DOESN'T WORK FOR SOME REASON
/*
    float e = 2.718281828;
    float pi = 3.141592653;
    float s = u_amount;

    for(int i=0; i<5; i++)
    {
        if(i>=n)
            break;
        for(int j=0; j<5; j++)
        {
            if(j>=n)
                break;
            int x = i-n/2;
            int y = j-n/2;
            r[i].c[j] = 1.0/2.0/pi/s/s * pow(e,-float(x*x+y*y)/2.0/s/s);
        }
    }
*/

    // HARDCODING THE 5*5 KERNEL

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

    return col;
}

void main() {
    vec4 col = filter(f_uv,5);
    gl_FragColor = col;
}
