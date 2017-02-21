
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {

    vec2 size = vec2(100.0,100.0); // size of the area to be warped
    vec2 t = f_uv * size; // texture coordinate
    t = t-vec2(50.0,50.0);
    float dist = length(t); // using this to check if a point is in the warped area..
    if (dist < 50.0)
    {
      float p = (100.0 - dist) / 100.0; // more distortion as we go radially outward..
      float theta = p * p * u_amount; // calculating the angle based on the amount from the GUI
      float s = sin(theta);
      float c = cos(theta);
      t = vec2(dot(t, vec2(c, -s)), dot(t, vec2(s, c))); // magic math
    }
    t += vec2(50.0,50.0);

    vec4 col = texture2D(tDiffuse, t / size);

    gl_FragColor = col;
}
