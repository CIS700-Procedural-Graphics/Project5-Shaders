
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to

void main() {
    vec4 color = texture2D(tDiffuse, f_uv);

    color.x = 0.393 * (color.x * 255.0) + 0.769*(color.y*255.0) + 0.189*(color.z*255.0);
	color.y = 0.349 * (color.x*255.0) + 0.686*(color.y*255.0) + 0.168*(color.z*255.0);
	color.z = 0.272 * (color.x*255.0) + 0.534*(color.y*255.0) + 0.131*(color.z*255.0);

	color.x /= 255.0;
	color.y /= 255.0;
	color.z /= 255.0;

    gl_FragColor = color;
}   