
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_cameraPos;
uniform float u_numShades;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    vec4 toonCol = (d + 0.5) * color;
    float n = pow(u_numShades, 1.0 / 3.0);
    toonCol.r = floor(toonCol.r * n) / n;
    toonCol.g = floor(toonCol.g * n) / n;
    toonCol.b = floor(toonCol.b * n) / n;

    if (dot(f_normal, normalize(u_cameraPos - f_position)) < 0.4) {
    	toonCol = vec4(0, 0, 0, toonCol.a);
    }

    gl_FragColor = vec4(toonCol.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}