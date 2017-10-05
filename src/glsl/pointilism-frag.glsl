uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 CamPos;
uniform float u_threshold;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

float Noisehash(vec3 p)
{
  p  = fract( p*0.3183099+0.1 );
  p *= 17.0;
  return fract( p.x*p.y*p.z*(p.x+p.y+p.z) );
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }
    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    float t = clamp(d - u_threshold, 0.0, 1.0);

    float rand = Noisehash(f_position*f_normal);
    int count =0;
    for(int i=0; i < 5; i++)
    {
      count++;
      if(i > int(floor(u_threshold*5.0)/5.0))
      {
        break;
      }
      rand = Noisehash(vec3(rand));
    }

    float blackoutline = clamp(dot(f_normal, normalize(CamPos - f_position)), 0.0, 1.0);
    // blackoutline = blackoutline * 10.0;
    // blackoutline = floor(blackoutline)/10.0;
    if(blackoutline > (u_threshold)) blackoutline =1.0;
    else blackoutline= 0.0;

    gl_FragColor = vec4(blackoutline * rand * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
