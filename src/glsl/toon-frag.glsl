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

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    float nor = clamp(dot(f_normal, normalize(cameraPosition-f_position)),0.0,1.0); // USING CAMERAPOS-FPOS FOR VIEW DIRECTION..
    if(nor<=0.2)
        d=0.0;

    d=floor(d*3.0)/3.0;
    vec4 final = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
    final.x = (floor(final.x*4.0)/4.0);
    final.y = (floor(final.y*4.0)/4.0);
    final.z = (floor(final.z*4.0)/4.0);

    gl_FragColor = final;
}
