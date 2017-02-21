varying vec2 f_uv;
varying vec3 pos;

void main() {
    f_uv = uv;
    pos = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}