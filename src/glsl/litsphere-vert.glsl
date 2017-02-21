
varying vec3 f_normal;
varying vec3 e_position;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_normal = normalMatrix * normal;
    e_position = normalize(vec3((modelViewMatrix * vec4(position, 1.0)).rgb));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}