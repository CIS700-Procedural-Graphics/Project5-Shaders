varying vec2 vNormal;

void main(){

	vec4 vertPos = vec4(position, 1.0);

	vec3 eye = normalize(vec3(modelViewMatrix * vertPos)); 
	vec3 screenNormal = normalize(normalMatrix * normal);

	vec3 reflected= reflect(eye, screenNormal);
	float m = 2.0 * sqrt( 
        pow( reflected.x, 2.0 ) + 
        pow( reflected.y, 2.0 ) + 
        pow( reflected.z + 1.0, 2.0 ) 
    );
    vNormal = reflected.xy/m + 0.50;

    gl_Position = projectionMatrix * modelViewMatrix * vertPos; 

}