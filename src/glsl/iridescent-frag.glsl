
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

uniform vec3 u_camPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

varying vec3 look;


// References
// Palette: http://www.iquilezles.org/www/articles/palettes/palettes.htm

vec3 a = vec3(0.5);
vec3 b = vec3(0.5);
vec3 c = vec3(2.0, 1.0, 0.0);
vec3 d = vec3(0.5, 0.2, 0.2);

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    vec3 look = -normalize(f_position - u_camPos);
    float iridescent = dot(f_normal, look);
    gl_FragColor = vec4(palette(iridescent, a, b, c, d), 1.0);
}