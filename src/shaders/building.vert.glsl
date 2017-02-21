varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vColor;
varying float localHeight;

uniform float time;

float displace(float x)
{
	x = smoothstep(-1.0, 1.0, sin(x));
	x = smoothstep(0.0, 1.0, x);
	x = smoothstep(0.0, 1.0, x);
	// x = smoothstep(0.0, 1.0, x);
	return x;
}

void main() {
    vUv = uv;
    vColor = color;
    vNormal = vec3(modelMatrix * vec4(normal, 0.0));
    localHeight = position.y;

    vec3 pos = position.xyz;

    float verticalMask = clamp((time - 15.0) * 4.0, 0.0, 1.0);

    pos.y *= verticalMask;

    // Displace Red 
	pos.y *= (1.0 + (displace(color.r * 3.1415 * 2.0 + time * 3.1415 * 2.0 * 1.25)) * verticalMask * .4);

    // pos.y *= (1.0 + (sin(color.r + color.g + color.b + time * 3.1415 * 2.0)) * verticalMask * .2);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}