
// we use this vertex shader for the post process steps. All we do is copy the uv value and set position appropriately
varying vec3 fPos; 

varying vec2 f_uv;
void main() {
    f_uv = uv;
    fPos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}