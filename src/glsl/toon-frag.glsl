
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_camPos;
uniform vec3 u_camDir;
varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    vec3 finalColor = d * color.rgb * u_lightCol * u_lightIntensity + u_ambient;
   	finalColor.x = floor(finalColor.x*3.0)/3.0;
   	finalColor.y = floor(finalColor.y*3.0)/3.0;
   	finalColor.z = floor(finalColor.z*3.0)/3.0;
   	vec3 view_vec = -normalize(u_camPos - f_position);
   	if (abs(dot(f_normal, view_vec)) <=  0.4) {
   		finalColor = vec3(0.0, 0.0, 0.0);
   	}
    gl_FragColor = vec4(finalColor, 1.0);
}