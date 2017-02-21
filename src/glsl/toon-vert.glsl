
varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;
varying float f_border;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_uv = uv;
    f_normal = normal;
    f_position = position;
    vec3 camera_ray = normalize(position - cameraPosition);
    f_border = abs(dot(camera_ray, normal));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
