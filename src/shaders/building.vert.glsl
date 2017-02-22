varying vec2 vUv;
varying vec3 vNormal;
varying vec4 wsPos;
varying vec3 vColor;
varying float localHeight;

uniform float time;
uniform float animateHeight;

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
    wsPos = modelMatrix * vec4(position, 1.0);
    vNormal = vec3(modelMatrix * vec4(normal, 0.0));
    localHeight = position.y;

    vec3 pos = position.xyz;

    float verticalMask = smoothstep(0.0, 1.0, clamp((time - 14.8) * 4.0, 0.0, 1.0));

    pos.y *= verticalMask + .15;

    // Displace Red 
	pos.y *= (1.0 + (animateHeight * displace(color.r * 3.1415 * 2.0 + time * 3.1415 * 2.0 * 1.25)) * verticalMask * .4);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}