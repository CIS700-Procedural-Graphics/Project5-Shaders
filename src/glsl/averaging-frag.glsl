
uniform sampler2D tDiffuse;
uniform int u_amount;
uniform float u_aspectx;
uniform float u_aspecty;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

struct kernel
{
    vec4 c[5];
};

vec4 filter(in vec2 uv, in int n) // KERNEL OF N*N AROUND POINT X,Y
{
    vec4 col;
    //kernel r[5];

	for(int i=0; i<9; i++)
    {
        if(i==n)
            break;
        for(int j=0; j<9; j++)
        {
            if(j==n)
                break;
            vec2 uvnew = vec2(uv.x + float(i-n/2)/u_aspectx, uv.y + float(j-n/2)/u_aspecty);
            //r[i].c[j] = 1.0/25.0 * texture2D(tDiffuse, uvnew);
            col += texture2D(tDiffuse, uvnew);
        }
    }

    return vec4(col.rgb/float(n)/float(n),1.0);
}

void main() {
    vec4 col = filter(f_uv,u_amount);
    gl_FragColor = col;
}
