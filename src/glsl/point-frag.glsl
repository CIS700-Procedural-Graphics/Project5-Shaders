
uniform sampler2D tDiffuse;
uniform float u_threshold;
uniform float u_kernel[9];
uniform vec2 u_scale;
varying vec2 f_uv;

// some standard noise function
float rand(vec2 coord){
    return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float luminosity(vec4 color) {
  return (0.2126*color.x + 0.7152*color.y + 0.0722*color.z);
}

vec4 threshold(vec4 color, vec2 loc) {
  float lum = luminosity(color);
  if (rand(loc) > lum) {
    color = vec4(0.,0.,0.,1.);
  } else {
    color = vec4(1., 1., 1., 1.);
  }
  return color;
}

void main() {
  vec4 color = texture2D(tDiffuse, f_uv);

  gl_FragColor = threshold(color, f_uv);
}
