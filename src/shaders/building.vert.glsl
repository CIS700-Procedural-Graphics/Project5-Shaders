varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vColor;
varying float localHeight;

uniform float time;

void main() {
    vUv = uv;
    vColor = color;
    vNormal = normalMatrix * normal;
    localHeight = position.y;

    vec3 pos = position.xyz;

    float verticalMask = clamp(time - 15.0, 0.0, 1.0);

    pos.y *= verticalMask;
    pos.y *= (1.0 + (sin(color.r + color.g + color.b + time * 3.1415 * 2.0)) * verticalMask * .2);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}