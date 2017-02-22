
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

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

 // 	mat3 sobelX = mat3(vec3(-0.1, 0.0, 0.1), 
 //                  	   vec3(-0.2, 0.0, 0.2), 
 //                       vec3(-0.1, 0.0, 0.1));
	// // weightings for y dir
 //    mat3 sobelY = mat3(vec3(-0.1,-0.1,-0.1),
 //    			   	   vec3(0.0, 0.0, 0.0),
 //    			   	   vec3(0.1, 0.2, 0.1));

    vec4 pixel_x = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 pixel_y = vec4(0.0, 0.0, 0.0, 1.0);

    // so can use floats and ints for uvLoc and for sobel array indexing
    float uvI = -1.0;
    float uvJ = -1.0;
    for (int i= -1; i < 2; i++) {
		for (int j = -1; j < 2; j++) {
			pixel_x += texture2D(tDiffuse, f_uv + vec2(uvI,uvJ)) * sobelX[i+1][j+1];
			pixel_y += texture2D(tDiffuse, f_uv + vec2(uvI,uvJ)) * sobelY[i+1][j+1];

			uvJ += 1.0;
		}
		uvI += 1.0;
		uvJ = -1.0;
    }

    // doing sobel manually
    // pixel_x += sobelX[0][0] * texture2D(tDiffuse, f_uv + vec2(-1, -1))
    // 		+  sobelX[0][1] * texture2D(tDiffuse, f_uv + vec2(-1, 0))
    // 		+  sobelX[0][2] * texture2D(tDiffuse, f_uv + vec2(-1, 1))
    // 		+  sobelX[1][0] * texture2D(tDiffuse, f_uv + vec2(0, -1))
    // 		+  sobelX[1][1] * texture2D(tDiffuse, f_uv + vec2(0, 0))
    // 		+  sobelX[1][2] * texture2D(tDiffuse, f_uv + vec2(0, 1))
    // 		+  sobelX[2][0] * texture2D(tDiffuse, f_uv + vec2(1, -1))
    // 		+  sobelX[2][1] * texture2D(tDiffuse, f_uv + vec2(1, 0))
    // 		+  sobelX[2][2] * texture2D(tDiffuse, f_uv + vec2(1, 1));
    // pixel_y += sobelY[0][0] * texture2D(tDiffuse, f_uv + vec2(-1, -1))
    // 		+  sobelY[0][1] * texture2D(tDiffuse, f_uv + vec2(-1, 0))
    // 		+  sobelY[0][2] * texture2D(tDiffuse, f_uv + vec2(-1, 1))
    // 		+  sobelY[1][0] * texture2D(tDiffuse, f_uv + vec2(0, -1))
    // 		+  sobelY[1][1] * texture2D(tDiffuse, f_uv + vec2(0, 0))
    // 		+  sobelY[1][2] * texture2D(tDiffuse, f_uv + vec2(0, 1))
    // 		+  sobelY[2][0] * texture2D(tDiffuse, f_uv + vec2(1, -1))
    // 		+  sobelY[2][1] * texture2D(tDiffuse, f_uv + vec2(1, 0))
    // 		+  sobelY[2][2] * texture2D(tDiffuse, f_uv + vec2(1, 1));

    return sqrt((pixel_x * pixel_x) + (pixel_y * pixel_y));
 }

void main() {
    vec4 col = colorFunc();
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    col.rgb = vec3(gray, gray, gray) * (u_amount) + col.rgb * (1.0 - u_amount);

    gl_FragColor = col;
}   