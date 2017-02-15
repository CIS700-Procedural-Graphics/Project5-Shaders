uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform int u_numShades;
uniform vec3 u_camView;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    d = floor(d*float(u_numShades)) / float(u_numShades);

    vec3 outputCol = d * color.rgb * u_lightCol * u_lightIntensity + u_ambient;

    if(abs(dot(f_normal, normalize(u_camView - f_position))) < 0.3)
    {
    	outputCol = vec3(0.0, 0.0, 0.0);
    }

    gl_FragColor = vec4(outputCol, 1.0);
}