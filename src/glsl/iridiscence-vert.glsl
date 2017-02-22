
varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;
varying vec3 cameraPos;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_uv = uv;
    f_normal = normal;
    f_position = position;
    cameraPos = cameraPosition;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}