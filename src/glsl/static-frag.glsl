// my own proposed shader: Static! Best in action when mario is moving.
// random function pulled from stack overflow: http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl

uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_cameraPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

// this function is from SO
float rand(float x){
    return fract(sin(x) * 43758.5453);
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    // start off just like the toon shader... 
    vec3 camera_dir = normalize(u_cameraPos - f_position);
    float d = clamp(dot(f_normal, camera_dir), 0.0, 1.0);

    // randomize the resulting dot product
    color = vec4(rand(d), rand(d), rand(d), 1.0);
    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
    
}
