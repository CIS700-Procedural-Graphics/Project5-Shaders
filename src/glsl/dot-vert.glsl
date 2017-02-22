varying vec3 vNormal;
varying vec3 vPos;

void main(){

	vec4 vertPos = vec4(position, 1.0);

	vec3 eye = normalize(vec3(modelViewMatrix * vertPos)); 
	vec3 n = normalize(normalMatrix * normal);

	vNormal = n;
	vPos = position;
	
	gl_Position = projectionMatrix * modelViewMatrix * vertPos; 

}