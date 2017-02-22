varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position.xy * 2.0, .01, 1.0);
}