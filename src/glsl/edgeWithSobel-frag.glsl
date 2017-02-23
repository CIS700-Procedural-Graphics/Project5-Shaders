
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// http://setosa.io/ev/image-kernels/

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

vec4 colorFunc() {
 	// weightings for x dir
 	mat3 sobelX = mat3(vec3(-1.0, 0.0, 1.0), 
                  	   vec3(-2.0, 0.0, 2.0), 
                       vec3(-1.0, 0.0, 1.0));
	// weightings for y dir
    mat3 sobelY = mat3(vec3(-1.0,-2.0,-1.0),
    			   	   vec3(0.0, 0.0, 0.0),
    			   	   vec3(1.0, 2.0, 1.0));

    vec4 pixel_x = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 pixel_y = vec4(0.0, 0.0, 0.0, 1.0);

    // so can use floats and ints for uvLoc and for sobel array indexing
    float uvI = -0.01;
    float uvJ = -0.01;
    for (int i= -1; i < 2; i++) {
		for (int j = -1; j < 2; j++) {
			pixel_x += texture2D(tDiffuse, f_uv + vec2(uvI,uvJ)) * sobelX[i+1][j+1];
			pixel_y += texture2D(tDiffuse, f_uv + vec2(uvI,uvJ)) * sobelY[i+1][j+1];

			uvJ += 0.01;
		}
		uvI += 0.01;
		uvJ = -0.01;
    }

    return sqrt((pixel_x * pixel_x) + (pixel_y * pixel_y));
 }

void main() {
    vec4 col = colorFunc();
    //float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    //col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    gl_FragColor = col;
}   