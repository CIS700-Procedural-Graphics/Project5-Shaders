
// we use this vertex shader for the post process steps. All we do is copy the uv value and set position appropriately
// uniform count;
varying vec2 f_uv;

float Noisehash(vec3 p)
{
  p  = fract( p*0.3183099+0.1 );
  p *= 17.0;
  return fract( p.x*p.y*p.z*(p.x+p.y+p.z) );
}

void main() {
    f_uv = uv;
    vec3 t = vec3(f_uv, 0.0);
    vec3 new_uv = vec3( Noisehash(vec3( Noisehash(t) )) );
    f_uv = vec2(new_uv.x, new_uv.y);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
