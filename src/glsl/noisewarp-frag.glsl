/////////////////////////////////////////////////////////////////

//noise function taken from:
//https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float mod289(float x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 mod289(vec4 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 perm(vec4 x) {
    return mod289(((x * 34.0) + 1.0) * x);
}

float sample_noise(vec3 p) {
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

//////////////////////////////////////////////////////////////////

float linear_interpolate(float a, float b, float t) {
  return a * (1.0 - t) + b * t;
}

#define M_PI 3.1415926535897932384626433832795
float cosine_interpolate(float a, float b, float t) {
  float cos_t = (1.0 - cos(t * M_PI)) * 0.5;
  return linear_interpolate(a, b, cos_t);
}

float lattice_interpolate(vec3 pos) 
{
  //get the 8 corners of the cube
  vec3 P1 = vec3(floor(pos.x), floor(pos.y), floor(pos.z));
  vec3 P2 = vec3(P1.x + 1.0, P1.y, P1.z);
  vec3 P3 = vec3(P1.x, P1.y + 1.0, P1.z);
  vec3 P4 = vec3(P1.x, P1.y, P1.z + 1.0);
  vec3 P5 = vec3(P1.x + 1.0, P1.y + 1.0, P1.z);
  vec3 P6 = vec3(P1.x + 1.0, P1.y, P1.z + 1.0);
  vec3 P7 = vec3(P1.x, P1.y + 1.0, P1.z + 1.0);
  vec3 P8 = vec3(P1.x + 1.0, P1.y + 1.0, P1.z + 1.0);

  //get the noise values of the 8 corners
  float p1 = sample_noise(P1);
  float p2 = sample_noise(P2);
  float p3 = sample_noise(P3);
  float p4 = sample_noise(P4);
  float p5 = sample_noise(P5);
  float p6 = sample_noise(P6);
  float p7 = sample_noise(P7);
  float p8 = sample_noise(P8);

  //get the interpolated noise value of the 8 corners
  float xT = distance(P1.x, pos.x) / distance(P1.x, P2.x);
  float c1 = cosine_interpolate(p1, p2, xT);
  float c2 = cosine_interpolate(p3, p5, xT);
  float c3 = cosine_interpolate(p4, p6, xT);
  float c4 = cosine_interpolate(p7, p8, xT);

  float yT = distance(P1.y, pos.y) / distance(P1.y, P3.y);
  float b1 = cosine_interpolate(c1, c2, yT);
  float b2 = cosine_interpolate(c3, c4, yT);

  float zT = distance(P1.z, pos.z) / distance(P1.z, P4.z);
  float a = cosine_interpolate(b1, b2, zT);

  return a;
} 

float multioctave_noise(vec3 pos) {
  float persistence = 0.8;
  float total = 0.0;
  for (float octave = 0.0; octave < 3.0; octave++) {
      float frequency = pow(2.0, octave);
      float amplitude = pow(persistence, octave);
      total += lattice_interpolate(vec3(frequency) * pos) * amplitude;
  }
  return total;
}

/////////////////////////////////////////////////////////////////

uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;
varying vec3 f_position;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 col = texture2D(tDiffuse, vec2( 
    f_uv.x + multioctave_noise(vec3(f_uv.x*f_uv.x*20.0, f_uv.y*f_uv.y*20.0, f_uv.y*20.0)) * u_amount*0.03 - u_amount*0.03, 
    f_uv.y + multioctave_noise(vec3(f_uv.y*f_uv.y*20.0, f_uv.x*f_uv.x*20.0, f_uv.x*20.0)) * u_amount*0.03 - u_amount*0.03));

    gl_FragColor = col;
}  

