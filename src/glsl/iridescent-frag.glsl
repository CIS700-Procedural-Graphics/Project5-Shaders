
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

uniform vec4 u_red;
uniform vec4 u_green;
uniform vec4 u_blue;
uniform float u_repeat;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {

    vec3 viewdir = normalize(cameraPosition-f_position);
    float vdotn = dot(-viewdir,f_normal);
    vdotn = vdotn * u_repeat * 3.14;

    // CREATING A PALLETE AND MAPPING THE VALUE OF V.N TO GET THE COLOR
    float cosr = u_red.x + u_red.y * cos(2.0 * 3.14 * u_red.z * vdotn+ u_red.w);
    float cosg = u_green.x + u_green.y * cos(2.0 * 3.14 * u_green.z * vdotn + u_green.w);
    float cosb = u_blue.x + u_blue.y * cos(2.0 * 3.14 * u_blue.z * vdotn + u_blue.w);
    vec3 color = vec3(min(cosr,1.0),min(cosg,1.0),min(cosb,1.0));

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);
    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
