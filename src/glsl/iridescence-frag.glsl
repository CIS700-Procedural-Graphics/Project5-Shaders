// Predefined in variables due to THREE.js
//		"uniform mat4 viewMatrix;",
//		"uniform vec3 cameraPosition;"

 #define M_PI 3.1415926535897932384626433832795

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

float colorFunc(float t, float rgb) {
	float a = 0.5;
	float b = 0.5;
	float c = 1.0;
	float d = 0.0;

	// r component
	if (rgb == 0.0) {
		d = 0.0;
	// g component
	} else if (rgb == 1.0) {
		d = .33;
	// b component
	} else if (rgb == 2.0) {
		d = .67;
	} else {
		d = -1.0; // want to error because inputed wrong rgb val
	}

	return a + b * cos(2.0 * M_PI * (c*t + d));
}

void main() {
    // not including texture color because did not look nice together with iridescence

    float d = clamp(dot(f_normal, normalize(cameraPosition - f_position)), 0.0, 1.0);
    // d = dot between frag normal and ray from camera to frag vertex
    // using d as weight on color palette

    // getting color value based on cos function
	gl_FragColor = vec4(colorFunc(d, 0.0), colorFunc(d, 1.0), colorFunc(d, 2.0), 1.0);    
}

