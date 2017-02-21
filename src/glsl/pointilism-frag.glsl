
uniform sampler2D texture;
uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform float u_strength;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

float random(in float x, in float y, in float z)
{
    float a;
	a=fract(sin(dot(vec3(x,y,z),vec3(12.9898,78.233,138.531))) * 43758.5453);
    a = (a+1.0)/2.0;
    return a;
}

void main()
{
    vec4 color = vec4(u_albedo, 1.0);

    if (u_useTexture == 1)
    {
        color = texture2D(texture, f_uv);
    }

    vec4 col = vec4(color.rgb * u_lightCol * u_lightIntensity + u_ambient, 1.0);
    //vec4 col = vec4(color.rgb * u_lightCol,1.0);
    float wt = random(f_position.x, f_position.y, f_position.z);

    if(wt-0.5> (color.x+color.y+color.z)/3.0 * u_strength)
    {
        col.x = 0.0;
        col.y = 0.0;
        col.z = 0.0;
    }

    gl_FragColor = col;
}
