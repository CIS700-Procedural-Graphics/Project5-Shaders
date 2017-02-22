
uniform sampler2D tDiffuse;
varying vec2 f_uv;

uniform float u_amount;
vec4 amount[8];

void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    if (col.rgb == vec3(0.6, 0.6, 0.6))
    {
        gl_FragColor = col;
        return;
    }

    else
    {
        amount[0] = vec4(1, -1, 1, -1);
        amount[1] = vec4(1, 1, 1, 1);
        amount[2] = vec4(-1, -1, -1, -1);
        amount[3] = vec4(-1, 1, -1, 1);
        amount[4] = vec4(0, 1, 0, 2);
        amount[5] = vec4(0, -1, 0, -2);
        amount[6] = vec4(1, 0, 2, 0);
        amount[7] = vec4(-1, 0, -2, 0);

        vec4 h = vec4(0.0, 0.0, 0.0, 0.0);
        vec4 v = vec4(0.0, 0.0, 0.0, 0.0);

        for (int i = 0; i < 4; i++)
        {
            amount[i].x *= u_amount * 0.002;
            amount[i].y *= u_amount * 0.002;

            h += amount[i].z * texture2D(tDiffuse, vec2(f_uv[0] + amount[i].x, f_uv[1] + amount[i].y));
            v += amount[i].w * texture2D(tDiffuse, vec2(f_uv[0] + amount[i].x, f_uv[1] + amount[i].y));
        }

        gl_FragColor = sqrt(h * h + v * v);
    }
}  