uniform sampler2D matcap;

varying vec3 f_normal;
varying vec3 f_cameraPos;

void main() {

    vec3 ref = reflect(f_cameraPos, f_normal);
    float sphereRad = 2.0 * sqrt(ref.x * ref.x + ref.y * ref.y + (ref.z + 1.0) * (ref.z + 1.0));
    vec2 m = ref.xy / sphereRad + 0.5;

    vec4 col = texture2D(matcap, m);

    gl_FragColor = col;
}