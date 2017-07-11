#define PI 3.14159
#define EPSILON 0.00001
#define DEG2RAD 0.0174533
#define RAD2DEG 57.295823
#define MAX_LIGHTS 5


uniform sampler2D texture;
uniform int u_useTexture;

uniform float u_exposure;
uniform vec3 u_albedo;
uniform vec3 u_specularColor;
uniform vec3 u_ambient;
uniform float u_specularExponent;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;
varying vec3 f_view;

struct lightInfo 
{
    vec3 location;
    vec3 direction;
    int type;
    float intensity;
    vec3 color;
    float intensity2;
    vec3 color2;
    float inner;
    float outer;
};

uniform lightInfo u_lights[MAX_LIGHTS];

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

// get the closest point on a ray to a plane
vec3 planeProject (vec3 org, vec3 dir, vec3 normal, vec3 p0, inout int pass) {
    float d = dot(dir, normal);
    if (d < EPSILON) {
        // perpendicular or reverse, want the projection of origin to plane
        return -dot(normal, p0-org) * normal + org;
    }

    float t = dot(p0 - org, normal) / d;
    return org + t * dir;
}

/*
Given a rect defined by center, up, right, half width and half height
a position (assumed on same plane),
return closest point to position within rectangle
*/
vec3 rectClamp(vec3 center, vec3 right, vec3 up, vec3 pos, vec2 wh) {
    float r = dot(pos - center, right);
    float u = dot(pos - center, up);
    r = clamp(r, -wh.x, wh.x);
    u = clamp(u, -wh.y, wh.y);
    return center + r * right + u * up;
}

vec3 evaluateSingleLight(lightInfo light, matInfo material) {
	vec3 col;
    vec3 halfVec;
	if (light.type == invalid) {

		return vec3(0);

	} else if (light.type == ambient) {

		return light.intensity * light.color * material.diffuseColor;

	} else if (light.type == point) {
        // calculate direction and distance based intensity
		vec3 disp = f_position - light.location;
		light.intensity *= 1000.0 / (dot(disp, disp) * 4.0 * PI + EPSILON);
		light.direction = normalize(disp);
        halfVec = normalize(material.view - light.direction);
    } else if (light.type == distant) {
        // do nothing. ech.
        halfVec = normalize(material.view - light.direction);
    } else if (light.type == spot) {
        // adjust light to cone
        vec3 disp = f_position - light.location;
        float denom = light.outer - light.inner;
        denom = abs(denom) < EPSILON ? EPSILON : denom;
        float angle = RAD2DEG * acos(dot(normalize(disp), light.direction));
        light.direction = normalize(disp);
        light.intensity *= clamp((light.outer - angle) / denom, 0.0, 1.0);
        if (light.intensity < EPSILON) return vec3(0);
        halfVec = normalize(material.view - light.direction);
    } else if (light.type == flash) {
        // infite point at the camera, override position and direction
        light.location = f_view;
        light.direction = normalize(f_position - f_view);
        halfVec = normalize(material.view - light.direction);
    } else if (light.type == area) {
        // Sebastien Lagarde, Charles de Rousiers, "Moving Frostbite to Physically Based Rendering 3.0"
        vec3 disp = f_position - light.location;
        if (dot(disp, light.direction) < 0.0) return vec3(0);
        float halfWidth = light.inner;
        float halfHeight = light.outer;
        vec3 worldUp = (1.0 - abs(dot(vec3(0, 1, 0), light.direction)))< EPSILON ? vec3(0, 0, -1) : vec3(0, 1, 0);
        vec3 right = normalize(cross(light.direction, worldUp));
        vec3 up = normalize(cross(right, light.direction));

        vec3 p0 = light.location + halfWidth * right + halfHeight * up;
        vec3 p1 = light.location + halfWidth * right - halfHeight * up;
        vec3 p2 = light.location - halfWidth * right - halfHeight * up;
        vec3 p3 = light.location - halfWidth * right + halfHeight * up;

        vec3 v0 = normalize(p0 - f_position);
        vec3 v1 = normalize(p1 - f_position);
        vec3 v2 = normalize(p2 - f_position);
        vec3 v3 = normalize(p3 - f_position);

        float c0 = acos(dot(v0, v1));
        float c1 = acos(dot(v1, v2));
        float c2 = acos(dot(v2, v3));
        float c3 = acos(dot(v3, v0));

        vec3 vx0 = normalize(cross(v0, v1)) * c0;
        vec3 vx1 = normalize(cross(v1, v2)) * c1;
        vec3 vx2 = normalize(cross(v2, v3)) * c2;
        vec3 vx3 = normalize(cross(v3, v0)) * c3;

        vec3 weightedLightVec = vx0 + vx1 + vx2 + vx3;

        // 'representative point' for specular:
        // get nearest point to reflection, treat that as light origin
        vec3 refl = normalize(reflect(-material.view, material.normal));
        int test = 1;
        // raycast to plane. if miss, project ray origin onto plane
        vec3 planar = planeProject(f_position, -refl, light.direction, light.location, test);
        vec3 bestplanar = rectClamp(light.location, right, up, planar, vec2(halfWidth, halfHeight));

        light.intensity *= length(weightedLightVec);
        light.direction = normalize(weightedLightVec);
        halfVec = test == 1 ? normalize(normalize(bestplanar - f_position) + material.view): normalize(material.view - light.direction);        
    } else return vec3(0);


    float face_diff = clamp(dot(-light.direction, material.normal), 0.0, 1.0);
    col = material.kd * face_diff * material.diffuseColor;
    
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

    vec3 col = vec3(0.0);

    for (int i = 0; i < MAX_LIGHTS; i++) {
        col += evaluateSingleLight(u_lights[i], mat);
    }

    col = toneMap(col);

    gl_FragColor = vec4(col, 1.0);
}