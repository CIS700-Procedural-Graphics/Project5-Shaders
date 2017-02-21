
uniform sampler2D texture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_viewPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;
varying float noise;

// some standard noise function
float rand(vec2 coord){
    return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    // color = texture2D(texture, vec2(f_uv.x - d * float(noise), f_uv.y - d * float(noise)));
    color = texture2D(texture, f_uv);

    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}
