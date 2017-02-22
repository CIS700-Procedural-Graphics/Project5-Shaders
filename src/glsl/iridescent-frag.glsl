
uniform sampler2D texture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_cameraPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

// cosine based palette, 4 vec3 params from http://www.iquilezles.org/www/articles/palettes/palettes.htm
vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
    vec4 color = vec4(u_albedo, 1.0);

	vec3 look = normalize(u_cameraPos-f_position);	
    float d = dot(look, f_normal);

    vec3 paletteColor = palette(d, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(1.0, 1.0, 1.0), vec3(0.00, 0.33, 0.67));

	gl_FragColor = vec4(paletteColor * color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
}