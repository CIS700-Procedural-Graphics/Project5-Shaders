// Special thanks to Hamoudi Moneimne for research and reference implementation of realtime PBR

#define PI 3.14159
#define EPSILON 0.00001
#define DEG2RAD 0.0174533
#define RAD2DEG 57.295823

uniform sampler2D texture;
uniform sampler2D brdfLUT;
uniform samplerCube cubeTexture;
uniform samplerCube cubeDiffTexture;
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

uniform vec3 u_albedo;
uniform vec3 u_specularColor;
uniform vec3 u_ambient;
uniform float u_roughness;
uniform float u_metalness;

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
	float roughness; 
	float metalness; 
	vec3 diffuseColor;
	vec3 specularColor;
	vec3 normal;
	vec3 view;
};

// From Hamoudi Moneimne's reference implementation
struct pbrInfo
{
    float NdotL;
    float NdotV;
    float NdotH;
    float LdotH;
    float VdotH;
    float roughness;
    float metalness;
    vec3 albedo;
    vec3 reflectance0;
    vec3 reflectance90;
};

// Cristopher Schlick, "An Inexpensive BRDF Model for Physically based Rendering"
vec3 fresnelSchlick(pbrInfo pbr) {
    return pbr.reflectance0 + (pbr.reflectance90 - pbr.reflectance0) * pow(clamp(1.0 - pbr.VdotH, 0.0, 1.0), 5.0);
}

vec3 fresnelSchlickMetal(pbrInfo pbr) {
    return pbr.metalness + (vec3(1.0) - pbr.metalness) * pow(1.0 - pbr.VdotH, 5.0);
}

vec3 fresnelSchlick2(float NdotV, vec3 spec) {
    return spec + (1.0 - spec) * pow(1.0 - NdotV, 5.0);
}

// Bruce G. Smith, "Geometrical Shadowing of a Rough Surface"
float smithG1(float NdotV, float r) {
    float ts = (1.0 - NdotV * NdotV) / max(NdotV * NdotV, EPSILON);
    return 2.0 / (1.0 + sqrt(1.0 + r * r * ts));
}

float geometricOcclusion(pbrInfo pbr) {
    return smithG1(pbr.NdotL, pbr.roughness) * smithG1(pbr.NdotV, pbr.roughness);
}

// T.S. Trowbridge, K.P. Reitz
float distributionGGX(pbrInfo pbr) {
    float alpha = pbr.roughness * pbr.roughness;
    float f = (pbr.NdotH * alpha - pbr.NdotH) * pbr.NdotH + 1.0;
    return alpha / (PI * f * f);
}

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

    vec3 halfVec = normalize(material.view - light.direction);

    float NdotL = clamp(dot(material.normal, -light.direction), EPSILON, 1.0);
    float NdotV = abs(dot(material.normal, material.view)) + EPSILON;
    float NdotH = clamp(dot(material.normal, halfVec), 0.0, 1.0);
    float LdotH = clamp(dot(-light.direction, halfVec), 0.0, 1.0);
    float VdotH = clamp(dot(material.view, halfVec), 0.0, 1.0);

    float metalness = clamp(material.metalness, 0.0, 1.0);
    float roughness = clamp(material.roughness, 0.03, 1.0);

    vec3 f0 = vec3(0.04);
    vec3 diffuse = material.diffuseColor;//mix(material.diffuseColor * (1.0 - f0), vec3(0.0), metalness);
    vec3 specular = material.specularColor;//mix(f0, material.diffuseColor, metalness);

    float refl = max(max(specular.r, specular.g), specular.b);
    float refl90 = clamp(refl * 25.0, 0.0, 1.0);
    vec3 specEnvR0 = specular;
    vec3 specEnvR90 = vec3(refl90);


    pbrInfo pbrVals = pbrInfo(
        NdotL,
        NdotV,
        NdotH,
        LdotH,
        VdotH,
        roughness,
        metalness,
        diffuse,
        specEnvR0,
        specEnvR90
        );

    //vec3 F = fresnelSchlick2(NdotV, specular);
    vec3 F = fresnelSchlick(pbrVals);
    float G = geometricOcclusion(pbrVals);
    float D = distributionGGX(pbrVals);
    //debug
    //return F;
    //return vec3(G);
    //return vec3(D);

    vec3 ambientLambert = (1.0 - F) * diffuse / PI;
    vec3 combinedSpecular = F * G * D / (4.0 * NdotL * NdotV);
    vec3 color = NdotL * light.color * light.intensity * (ambientLambert + combinedSpecular);
    return color;
}

vec3 IBLDiffuse(matInfo material) {
    return material.diffuseColor * textureCube(cubeDiffTexture, material.normal).rgb;
}

vec3 IBLSpecular(matInfo material) {
    vec3 reflected = -normalize(reflect(material.view, material.normal));
    float NdotV = abs(dot(material.normal, material.view));
    vec3 brdf = texture2D(brdfLUT, vec2(NdotV, material.roughness)).rgb;
    return (material.specularColor * brdf.x + brdf.y) * textureCube(cubeTexture, reflected).rgb; 
}

// testing, should be post
vec3 toneMap(vec3 unclampedColor) {
	vec3 map = vec3(1.0) - exp(-unclampedColor * u_exposure);
	return map;
}


void main() {
    vec4 color = vec4(u_albedo, 1.0);
    //f_normal = normalize(f_normal);
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    vec3 view_dir = normalize(f_view - f_position);
    vec3 f0 = vec3(0.04);
    vec3 diffuse = mix(color.rgb * (1.0 - f0), vec3(0.0), u_metalness);
    vec3 specular = mix(f0, color.rgb, u_metalness);

    matInfo mat = matInfo(
    	u_roughness, u_metalness,
    	diffuse, specular, normalize(f_normal), view_dir
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
    col += u_ambient * IBLDiffuse(mat);
    col += u_ambient * IBLSpecular(mat);
    col = toneMap(col);

    //col = IBLSpecular(mat);
    //col = IBLDiffuse(mat);
    //col = specular;

    // debug example half vector
    //col = 0.5 * normalize(f_view + normalize(vec3(1.0))) + vec3(0.5);

    // debug view vector
    //col = 0.5 * f_view + vec3(0.5);

    //  debug normals
    //col = 0.5 * f_normal + vec3(0.5);


    gl_FragColor = vec4(col, 1.0);
}