
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_cameraPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    vec3 camera_dir = normalize(u_cameraPos - f_position);
    vec4 final_col;

    // check for outline
    if (dot(f_normal, camera_dir) < 0.5) {
      final_col = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
      vec4 bucketColor = vec4(floor((d * color.rgb * u_lightCol + 0.3) * 5.0) / 5.0, 1.0);
      final_col = bucketColor;
    }
    gl_FragColor = final_col;
}
