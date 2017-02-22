uniform sampler2D tDiffuse;
uniform float aperture;
varying vec2 f_uv;
const float PI = 3.1415926535;

// uses the polar method from http://paulbourke.net/dome/fisheye/ 
void main() {
  float apertureHalf = 0.5 * aperture * (PI / 180.0);
  float maxFactor = sin(apertureHalf);
  
  vec2 uv;
  vec2 xy = 2.0 * f_uv.xy - 1.0;
  float d = length(xy);

  if (d < (2.0 - maxFactor)) {
    d = length(xy * maxFactor);
    float z = sqrt(1.0 - d * d);
    float r = atan(d, z) / PI;
    float phi = atan(xy.y, xy.x);
    
    uv.x = r * cos(phi) + 0.5;
    uv.y = r * sin(phi) + 0.5;
  } else {
    uv = f_uv.xy;
  }

  vec4 c = texture2D(tDiffuse, uv);
  gl_FragColor = c;
}