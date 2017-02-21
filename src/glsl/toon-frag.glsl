
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;
varying vec3 e_position;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    float edge = dot(f_normal, normalize(e_position- f_position));
    vec3 final = vec3(0.0);
    if (edge > 0.5) {
        float d = floor (3.0 * d) / 3.0;
    	final = d * color.rgb * u_lightCol * u_lightIntensity + u_ambient;
    }
    gl_FragColor = vec4(final.rgb, 1.0);
}