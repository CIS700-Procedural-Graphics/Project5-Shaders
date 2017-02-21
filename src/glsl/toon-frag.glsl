
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

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

//this is just for the outline of the whole thing. but it should be the dot product of camera to normal. not light vector. also offset it a bit

    if(clamp(dot(f_normal, normalize(cameraPosition - f_position)), 0.0, 1.0) < 0.1)
    {
        d = 0.0;
    }

    d = floor(d * 5.0) / 5.0;

//multiply dot product with an int, floor it, and then divide by that number

    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
