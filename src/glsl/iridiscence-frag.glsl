
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
varying vec3 cameraPos;

void main() {
    // vec4 color = vec4(u_albedo, 1.0);
    
    // if (u_useTexture == 1) {
    //     color = texture2D(texture, f_uv);
    // }

    float d = dot(f_normal, normalize(cameraPos - f_position));
    // d /= 2.0;
    
    //Create a color palette using cosines
    //http://www.iquilezles.org/www/articles/palettes/palettes.htm
    
    float cosineRedComponent = 0.5 + 0.5 * cos(6.28318 * (2.0 * d + 0.5));
    float cosineGreenComponent = 0.5 + 0.5 * cos(6.28318 * (d + 0.2));
    float cosineBlueComponent = 0.5 + 0.5 * cos(6.28318 * (0.25));
    
    vec3 color = vec3(cosineRedComponent, cosineGreenComponent, cosineBlueComponent);

    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}