
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

//from http://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
float darkness(vec4 c)
{
   return sqrt(
      c.r * c.r * .241 + 
      c.g * c.g * .691 + 
      c.b * c.b * .068);
}


void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    if (col.rgb == vec3(0.6, 0.6, 0.6))
    {
        gl_FragColor = col;
    }

    else

    {
      float sn = sin(f_uv.x * 800.0 - f_uv.y * 800.0);
        float sp = sin(f_uv.x * 800.0 + f_uv.y * 800.0);
        float d = darkness(col);
    
        if (sn < 0.3 && sp < 0.3)
        {
          col += (vec4(0.1, 0.1, 0.1, 1.0) * sin(2.0 * d * 3.14) * u_amount);
        }
    
        gl_FragColor = col;
      }
}   