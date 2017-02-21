
uniform sampler2D tDiffuse;
uniform float u_vignette;
uniform float time;

uniform float u_bandStrength;
uniform float u_noiseStrength;
uniform float u_bandSpeed;
uniform float u_bandWidth;
uniform float u_colorize;

uniform float u_scanStrength;
uniform float u_scanSpeed;
uniform float u_scanWidth;

varying vec2 f_uv;


// implementation of Rachel's noise generation
float rNoise(in float x, in float y) {
	return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // edge darkening
    float xd = f_uv.x - 0.5;
    float yd = f_uv.y - 0.5;
    float dist = u_vignette * sqrt(xd * xd + yd * yd);
    vec4 vignette = mix(vec4(1, 1, 1, 1), vec4(0, 0, 0, 1), dist * dist);

    // scan line
    float y = fract(0.1 * u_scanSpeed * time);
    float scanWidth = u_scanWidth * 0.05;
    float t = clamp((y - f_uv.y) / scanWidth, 0.0, 1.0);
    t = u_scanStrength * 0.2 * smoothstep(0.0, 1.0, t) * sign(t - 1.0);
    // distort reading by scan
    vec4 col = texture2D(tDiffuse, vec2(mod(f_uv.x + 0.2 * t, 1.0), f_uv.y));
    col += 2.0 * vec4(t, t, t, 0);
    
    // banding pattern
    float band = sin((1.0 - u_bandWidth) * 1000.0 * fract(f_uv.y + u_bandSpeed * time / 50.0));
    band = 1.0 + u_bandStrength * (band - 1.0);
    band *= 1.0 - u_noiseStrength;

    // white noise
    float noise = rNoise(11.777 * fract(f_uv.x + 2.347 * time), -4.0973 * fract(f_uv.y + 1.979 * time));
    float noise2 = rNoise(1.236 * fract(f_uv.x - 1.347 * time), -4.0973 * fract(f_uv.y + 4.458 * time));
    noise *= u_noiseStrength * noise2;

    // composite
    col = vignette * clamp(band * col + noise, vec4(0, 0, 0, 1), vec4(1, 1, 1, 1));

    // colorize approximation
    float brightness = dot(col.xyz, vec3(0.3, 0.59, 0.11));
    vec4 colorized = vec4(pow(brightness, 1.3), brightness, pow(brightness, 1.2), 1.0);

    col = mix(col, colorized, u_colorize);

    gl_FragColor = vec4(col.xyz, 1.0);
}   