// change the color of the points as well!

uniform sampler2D tDiffuse;
uniform float u_freq;
uniform vec3 u_color;
uniform float u_time;
uniform float u_amp;
varying vec2 f_uv;


// our favorite SO glsl random function! 
float rand(float x, float y, float z){
    return fract(sin(dot(vec3(x, y, z), vec3(12.9898, 12.9898, 78.233))) * 43758.5453);
}


// my noise functions
float lerp(float a, float b, float t) {
  return a * (1.0 - t) + b * t;
}

float cosine_interpolate(float a, float b, float t) {
  float cos_t = (1.0 - cos(t * 3.1459)) * 0.5;
  return lerp(a, b, cos_t);
}

float interpolate_noise(float x, float y, float z) {
  //pos
  float pos_NE = rand(ceil(x), ceil(y), ceil(z));
  float pos_NW = rand(floor(x), ceil(y), ceil(z));
  float pos_SW = rand(floor(x), ceil(y), floor(z));
  float pos_SE = rand(ceil(x), ceil(y), floor(z));

  //neg
  float neg_NE = rand(ceil(x), floor(y), ceil(z));
  float neg_NW = rand(floor(x), floor(y), ceil(z));
  float neg_SW = rand(floor(x), floor(y), floor(z));
  float neg_SE = rand(ceil(x), floor(y), floor(z));

  float x_t = ceil(x) - x;
  float z_t = ceil(z) - z;
  float y_t = ceil(y) - y;

  float pos_north = cosine_interpolate(pos_NE, pos_NW, x_t);
  float pos_south = cosine_interpolate(pos_SE, pos_SW, x_t);
  float pos_ns = cosine_interpolate(pos_north, pos_south, z_t);

  float neg_north = cosine_interpolate(neg_NE, neg_NW, x_t);
  float neg_south = cosine_interpolate(neg_SE, neg_SW, x_t);
  float neg_ns = cosine_interpolate(neg_north, neg_south, z_t);

  float res_noise = cosine_interpolate(pos_ns, neg_ns, y_t);

  // returned interpolated noise for a single point
  return res_noise;
}


void main() {
    float warp = interpolate_noise(f_uv.x, f_uv.y, u_amp * sin(u_time));
    vec2 new_uv = f_uv + vec2(-0.3 * warp * u_freq, 0.1 * warp * u_freq);
    gl_FragColor = texture2D(tDiffuse, new_uv); 
   
}

