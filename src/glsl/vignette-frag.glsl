uniform sampler2D tDiffuse;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
  vec4 color = texture2D(tDiffuse, f_uv);

  vec2 center = vec2(0.5,0.5);
  float outer = 1.0;
  float inner = 0.05;
  vec2 temp = center - f_uv;
  float dist = sqrt(temp.x*temp.x + temp.y*temp.y) * 1.414213; //multiply with 1.414 to bring back to a 0 to 1 range
                                                              //1.414 = 0.707 *2
                                                              //0.707 = sqrt(0.5)
  float vig = clamp((outer - dist*dist)/(outer-inner), 0.0, 1.0); // can be dist, using dist*dist for a better vignette boundary
  gl_FragColor = vec4(color.rgb * vig, 1.0);
}
