
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
uniform vec3 u_spotIntensity;
uniform float u_spotInnerAngle;
uniform float u_spotOuterAngle;

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


vec3 evaluateSingleLight(vec3 light_dir, vec3 view_dir, vec3 diffuse, vec3 specular, float specExp,
	float kd, float ks, float intensity) {

	vec3 col = vec3(0.0);
	vec3 halfVec = normalize(-light_dir + view_dir);

	float face_diff = max(0.0, dot(-light_dir, f_normal));
	col = face_diff * kd * intensity * diffuse;
	float face_spec = max(0.0, dot(halfVec, f_normal));
	col += pow(face_spec, specExp) * ks * intensity * specular;

	return col;
}

/*
vec3 evaluateSpotLight(vec3 light_dir, vec3 diffuse, vec3 specular, float specExp,
	float kd, float ks, float intensity, float u_spotInnerAngle, float u_spotOuterAngle, vec3 light_center) {
	vec3 col = vec3(0.0);
	 
	float angle = acos((max(0.0, dot(light_dir, light_center)));
	float angleintensity *= clamp((angle - outAngle) / (inAngle - outAngle),0.0, 1.0);
	return col;
}*/

// testing, should be post
vec3 toneMap(vec3 unclampedColor) {
	vec3 map = vec3(1.0) - exp(-unclampedColor * u_exposure);
	//map = pow(map, vec3(1.0 / u_gamma));
	return map;
}


void main() {
    vec4 color = vec4(u_albedo, 1.0);
    vec3 f_Newview = normalize(f_view - f_position);
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    vec3 col = evaluateSingleLight(normalize(f_position - u_lightPos), f_Newview, color.rgb, u_specularColor,
    	u_specularExponent, 0.7, 0.3, u_lightIntensity);

    col += evaluateSingleLight(u_dirLightDirection, f_Newview, color.rgb, u_specularColor, u_specularExponent,
    	0.1, 0.9, u_dirLightIntensity);
    col += u_ambient * color.rgb;
    col = toneMap(col);
    gl_FragColor = vec4(col, 1.0);
}