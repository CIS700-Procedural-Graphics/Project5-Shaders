uniform sampler2D tDiffuse;
uniform int u_amount;
uniform float u_aspectx;
uniform float u_aspecty;
uniform int u_divide;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

struct kernel
{
    float c[3];
};

vec4 filter(in vec2 uv, in int n) // KERNEL OF N*N AROUND POINT X,Y
{
    vec4 col;
    kernel r[3];

    // SETTING UP THE KERNEL
    if(u_divide==2) // LAPLACIAN
    {
        r[0].c[0] = 0.25;   r[0].c[1] = 0.5;   r[0].c[2] = 0.25;
        r[1].c[0] = 0.5;   r[1].c[1] = -3.0;   r[1].c[2] = 0.5;
        r[2].c[0] = 0.25;   r[2].c[1] = 0.5;   r[2].c[2] = 0.25;
    }
    else if(u_divide==1) // SOBEL VERTICAL
    {
        r[0].c[0] = -1.0;   r[0].c[1] = -2.0;   r[0].c[2] = -1.0;
        r[1].c[0] = 0.0;   r[1].c[1] = 0.0;   r[1].c[2] = 0.0;
        r[2].c[0] = 1.0;   r[2].c[1] = 2.0;   r[2].c[2] = 1.0;
    }
    else // SOBEL HORIZONTAL
    {
        r[0].c[0] = -1.0;   r[0].c[1] = 0.0;   r[0].c[2] = 1.0;
        r[1].c[0] = -2.0;   r[1].c[1] = 0.0;   r[1].c[2] = 2.0;
        r[2].c[0] = -1.0;   r[2].c[1] = 0.0;   r[2].c[2] = 1.0;
    }

    // CONVOLUTION
	for(int i=0; i<3; i++)
    {
        for(int j=0; j<3; j++)
        {
            vec2 uvnew = vec2(uv.x + float(i-n/2)/u_aspectx, uv.y + float(j-n/2)/u_aspecty);
            //r[i].c[j] = 1.0/25.0 * texture2D(tDiffuse, uvnew);
            col += r[i].c[j] * texture2D(tDiffuse, uvnew);
        }
    }

    return col;
}

void main() {
    vec4 col = filter(f_uv,3);
    gl_FragColor = col;
}
