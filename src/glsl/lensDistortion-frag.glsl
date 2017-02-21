uniform sampler2D tDiffuse;
uniform float u_lensSize;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main()
{
  vec2 center = vec2(0.5,0.5);
  vec2 temp = center - f_uv;
  float r = sqrt(temp.x*temp.x + temp.y*temp.y) * 1.414213;
  vec3 color;
  vec2 uv;

  if (r > u_lensSize+0.01)
  {
      color = texture2D(tDiffuse, f_uv).rgb;
  }
  else
  {
      float phi = atan(f_uv.y, f_uv.x);
      r=r*r*3.0; //affects distortion

      uv.x = r * cos(phi);
      uv.y = r * sin(phi);

      color = texture2D(tDiffuse, uv + 0.5).rgb;
  }

  gl_FragColor = vec4(color.rgb, 1.0);
}
