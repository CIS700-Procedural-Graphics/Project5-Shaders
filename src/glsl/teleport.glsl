
uniform sampler2D texture;
uniform sampler2D disintegrate;
uniform sampler2D ramp;

uniform int u_useTexture;
uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos;
uniform vec3 u_lightCol;
uniform float u_lightIntensity;

uniform float time;
uniform float u_edgeWidth;

uniform float topEdge;
uniform float botEdge;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;

void main() {
    vec4 color = vec4(u_albedo, 1.0);
    
    if (u_useTexture == 1) {
        color = texture2D(texture, f_uv);
    }

    // get the ramp from the threshold
    float y = 0.5 * (topEdge - botEdge) * (sin(time)) + 0.5 * (topEdge + botEdge);
    float top = y + u_edgeWidth;
    float bot = y - u_edgeWidth;
    float t = clamp((f_position.y - bot) / (top - bot), 0.0, 1.0);

    // modify ramp with tex noise shape
    float wsd = sqrt(f_position.x * f_position.x + f_position.z * f_position.z);
    vec2 wsuv = vec2(mod((f_position.x + f_position.z) * 0.025, 1.0), mod(0.05 * f_position.y, 1.0));
    float dis = clamp(texture2D(disintegrate, wsuv).x, 0.0, 1.0);

    // modulate tex by ramp: add if above .5, sub otherwise
    t = clamp(2.0 * t + dis - 1.0, 0.0, 1.0);
    float alpha = sign(t); // everything below ramp is masked
    float lit = sign(f_position.y - y); // lit if above top, otherwise unlit
    color = 0.5 * (color + lit * color);

    // get color from the ramp
    vec3 rcol = texture2D(ramp, vec2(0.5,t)).rgb;

    float d = clamp(dot(f_normal, normalize(u_lightPos - f_position)), 0.0, 1.0);

    gl_FragColor = vec4(d * color.rgb * u_lightCol * u_lightIntensity + u_ambient + rcol, alpha);
}