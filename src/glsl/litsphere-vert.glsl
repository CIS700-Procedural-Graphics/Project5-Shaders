/*

Reference : https://www.clicktorelease.com/blog/creating-spherical-environment-mapping-shader

*/

varying vec2 f_uv;
varying vec3 f_normal;
varying vec3 f_position;

void main() {
	
    f_normal = normal;
    f_position = position;
	
    vec4 pos = vec4(f_position, 1.0);

    vec3 eye = normalize(vec3(modelViewMatrix * pos)); //camera to vertex position
	//normalMatrix is inverse transpose of model view matrix
    vec3 nor = normalize(normalMatrix * f_normal); //normal in screen space

    vec3 reflected = reflect(eye, nor);
	
	f_uv.x = reflected.x / (2.0 * sqrt(pow(reflected.x, 2.0) + 
								       pow(reflected.y, 2.0) + 
        							   pow(reflected.z + 1.0, 2.0))) + 0.5;
	
	f_uv.y = reflected.y / (2.0 * sqrt(pow(reflected.x, 2.0) + 
								       pow(reflected.y, 2.0) + 
        							   pow(reflected.z + 1.0, 2.0))) + 0.5;

    gl_Position = projectionMatrix * modelViewMatrix * pos;
}