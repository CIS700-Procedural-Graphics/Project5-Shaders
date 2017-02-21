uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
//uniform float u_cameraPosition;


//red uniforms
uniform float u_Red_a;
uniform float u_Red_b;
uniform float u_Red_c;
uniform float u_Red_d;

//green uniforms
uniform float u_Green_a;
uniform float u_Green_b;
uniform float u_Green_c;
uniform float u_Green_d;

//blue uniforms
uniform float u_Blue_a;
uniform float u_Blue_b;
uniform float u_Blue_c;
uniform float u_Blue_d;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    float t = clamp(dot(f_normal, normalize(cameraPosition-f_position)), 0.0, 1.0);
    
    //getting the color pallet value
    color.r = u_Red_a + u_Red_b * cos(2.0 * 3.141 * (u_Red_c * t + u_Red_d)); //red color wave
    color.g = u_Green_a + u_Green_b * cos(2.0 * 3.141 * (u_Green_c * t + u_Green_d)); //green color wave
    color.b = u_Blue_a + u_Blue_b * cos(2.0 * 3.141 * (u_Blue_c * t + u_Blue_d)); //blue color wave
    
    vec4 final_col = vec4(u_albedo * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
    
    gl_FragColor = final_col;
    
}
