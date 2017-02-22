
varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;
varying float angle;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_uv = uv;
    f_normal = normal;
    f_position = position;
	vec3 view = normalize(cameraPosition - f_position);
	angle = acos(dot(f_normal, view));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}