
varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;

uniform float time;

// uv, position, projectionMatrix, modelViewMatrix, normal
void main() {
    f_uv = uv;
    f_normal = normal;



    vec3 p = (modelMatrix * vec4(position, 1.0)).xyz;
    float t = sin(time) * p.y;
    float ct = cos(t);
    float st = sin(t);

    f_position = p;

    f_position.x = p.x * ct - p.z * st;
    f_position.z = p.x * st + p.z * ct;

    mat3 jInvT = mat3(vec3(ct, st, p.z * sin(time)),
    			vec3(0.0, 1.0, 0.0),
    			vec3(-st, ct, -p.x * sin(time)));
    f_normal = jInvT * f_normal;

    gl_Position = projectionMatrix * viewMatrix * vec4(f_position, 1.0);
}