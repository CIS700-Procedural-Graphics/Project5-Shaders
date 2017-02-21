
varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;
varying vec2 v_n;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_uv = uv;
    f_normal = normal;
    f_position = position;
    // map normals to UVs
    vec3 r = reflect(normalize(vec3(modelViewMatrix * vec4(position, 1.0))), normalize(normalMatrix * normal));
    float m = 2.0 * sqrt(pow(r.x, 2.0) + pow(r.y, 2.0) + pow(r.z + 1.0, 2.0));
    v_n = r.xy / m + 0.5;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
