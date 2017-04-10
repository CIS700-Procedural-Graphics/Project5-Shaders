// Predefined in variables due to THREE.js
// 		"uniform mat4 modelMatrix;",
// 		"uniform mat4 modelViewMatrix;",
// 		"uniform mat4 projectionMatrix;",
// 		"uniform mat4 viewMatrix;",
// 		"uniform mat3 normalMatrix;",
// 		"uniform vec3 cameraPosition;"


varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_uv = uv;
    f_normal = normal;
    f_position = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}