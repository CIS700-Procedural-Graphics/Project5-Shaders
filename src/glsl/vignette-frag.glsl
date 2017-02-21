
uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


uniform vec2 resolution;
const float radius = 1.25;
const float softness = 0.5;


void main() {
    vec4 col = texture2D(tDiffuse, f_uv);

    vec2 offset = vec2(1.0);

    vec2 position = ((gl_FragCoord.xy / resolution.xy)) - offset;

    position.x *= resolution.x / resolution.y;

    float _length = length(position);

    float vignette = smoothstep(radius, radius - softness, _length);

    col.rgb = mix(col.rgb, col.rgb * vignette, 0.5);

    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    vec3 sepia = vec3(
    	clamp(gray * 0.393 + gray * 0.769 + gray * 0.189, 0.0, 1.0)
    , clamp(gray * 0.349 + gray * 0.686 + gray * 0.168, 0.0, 1.0)
    , clamp(gray * 0.272 + gray * 0.534 + gray * 0.131, 0.0, 1.0)
    );

    col.rgb = mix(col.rgb, sepia, 0.75);


    gl_FragColor = vec4(  col.rgb , 1.0  );
}
