#define PI 3.14159
#define EPSILON 0.00001
#define DEG2RAD 0.0174533
#define RAD2DEG 57.295823

uniform sampler2D texture;
uniform int u_useTexture;

uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

uniform vec3 u_dirLightDirection;
uniform vec3 u_dirLightCol;
uniform float u_dirLightIntensity;

uniform vec3 u_spotPos;
uniform vec3 u_spotDir;
uniform vec3 u_spotCol;
uniform float u_spotIntensity;
uniform float u_spotInner;
uniform float u_spotOuter;

uniform float u_exposure;
uniform float u_gamma;

uniform vec3 u_albedo;
uniform vec3 u_specularColor;
uniform vec3 u_ambient;
uniform float u_specularExponent;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;
varying vec3 f_view;

// definitions of light types
const int invalid = 0;
const int solar = 1;
const int ambient = 2;
const int flash = 3;
const int portrait = 4;
const int point = 5;
const int spot = 6;
const int area = 7;
const int distant = 8;
const int skyOpening = 9;

struct lightInfo 
{
	vec3 location;
	vec3 direction;
	int type;
	float intensity;
	vec3 color;
	float intensity2;
	vec3 color2;
	float kelvin;
	float inner;
	float outer;
};

struct matInfo
{
	float ks; // spec
	float kd; // diffuse
	float shininess;
	vec3 diffuseColor;
	vec3 specularColor;
	vec3 normal;
	vec3 view;
};

vec3 evaluateSingleLight(lightInfo light, matInfo material) {
	vec3 col;
	if (light.type == invalid) {

		return vec3(0);

	} else if (light.type == ambient) {

		return light.intensity * light.color * material.diffuseColor;

	} else if (light.type == point) {
        // calculate direction and distance based intensity
		vec3 disp = f_position - light.location;
		light.intensity *= 1000.0 / (dot(disp, disp) * 4.0 * PI + EPSILON);
		light.direction = normalize(disp);
    } else if (light.type == distant) {
        // do nothing. ech.
    } else if (light.type == spot) {
        // adjust light to cone
        vec3 disp = f_position - light.location;
        float denom = light.outer - light.inner;
        denom = abs(denom) < EPSILON ? EPSILON : denom;
        float angle = RAD2DEG * acos(dot(normalize(disp), light.direction));
        light.direction = normalize(disp);
        light.intensity *= clamp((light.outer - angle) / denom, 0.0, 1.0);
        if (light.intensity < EPSILON) return vec3(0);

    } else return vec3(0);


    float face_diff = clamp(dot(-light.direction, material.normal), 0.0, 1.0);
    col = material.kd * face_diff * material.diffuseColor;
    vec3 halfVec = normalize(material.view - light.direction);
    float face_spec = clamp(dot(halfVec, material.normal), 0.0, 1.0);
    col += material.ks * pow(face_spec, material.shininess) * material.specularColor;
	col *= light.intensity * light.color;
	return col;
}


// testing, should be post
vec3 toneMap(vec3 unclampedColor) {
	vec3 map = vec3(1.0) - exp(-unclampedColor * u_exposure);
	//map = pow(map, vec3(1.0 / u_gamma));
	return map;
}


void main() {
    vec4 color = vec4(u_albedo, 1.0);
    //f_normal = normalize(f_normal);
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    vec3 view_dir = normalize(f_view - f_position);

    matInfo mat = matInfo(
    	0.2, 0.8, u_specularExponent, 
    	color.rgb, u_specularColor, normalize(f_normal), view_dir
    	);

    lightInfo directional = lightInfo(
    	vec3(0),
    	u_dirLightDirection,
    	distant,
    	u_dirLightIntensity,
    	u_dirLightCol,
    	0.0,
    	vec3(0),
    	0.0,
    	0.0,
    	0.0
    	);

    lightInfo ambientLight = lightInfo(
    	vec3(0),
    	vec3(0),
    	ambient,
    	1.0,
    	u_ambient,
    	0.0,
    	vec3(0),
    	0.0,
    	0.0,
    	0.0
    	);

    lightInfo pointLight = lightInfo(
    	u_lightPos,
    	vec3(0),
    	point,
    	u_lightIntensity,
    	u_lightCol,
    	0.0,
    	vec3(0),
    	0.0,
    	0.0,
    	0.0
    	);

    lightInfo spotLight = lightInfo(
        u_spotPos,
        u_spotDir,
        spot,
        u_spotIntensity,
        u_spotCol,
        0.0,
        vec3(0),
        0.0,
        90.0 * u_spotInner,
        90.0 * u_spotOuter
        );

    vec3 col = evaluateSingleLight(directional, mat);
    col += evaluateSingleLight(ambientLight, mat);
    col += evaluateSingleLight(pointLight, mat);
    col += evaluateSingleLight(spotLight, mat);
    col = toneMap(col);


    // debug example half vector
    //col = 0.5 * normalize(f_view + normalize(vec3(1.0))) + vec3(0.5);

    // debug view vector
    //col = 0.5 * f_view + vec3(0.5);

    //  debug normals
    //col = 0.5 * f_normal + vec3(0.5);


    gl_FragColor = vec4(col, 1.0);
}