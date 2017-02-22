
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

uniform float u_width;
uniform float u_height;
uniform float u_time;

#define PI     3.14159265358
#define TWO_PI 6.28318530718

float radius = 200.0;
float angle = u_amount;
vec2 center = vec2(500.0, 400.0);

vec4 PostFX(in sampler2D tex,in vec2 uv,in float time)
{
  vec2 texSize = vec2(u_width, u_height);
  vec2 tc = uv * texSize;
  tc -= center;
  float dist = length(tc);
  if (dist < radius) 
  {
    float percent = (radius - dist) / radius;
    float theta = percent * percent * angle * 8.0;
    float s = sin(theta);
    float c = cos(theta);
    tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
  }
  tc += center;
  vec3 color = texture2D(tex, tc / texSize).rgb;
  return vec4(color, 1.0);
}

void main() {
  
  vec2 uv = f_uv.xy;
  gl_FragColor = PostFX(tDiffuse, uv, u_time);

}   