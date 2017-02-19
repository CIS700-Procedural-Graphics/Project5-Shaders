uniform sampler2D matcap;

varying vec3 f_position;
varying vec3 f_normal;
varying vec3 f_cameraPos;

void main() {

    f_cameraPos = normalize(vec3(modelViewMatrix * vec4(position, 1.0)));
    f_normal = normalize(normalMatrix * normal);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

}