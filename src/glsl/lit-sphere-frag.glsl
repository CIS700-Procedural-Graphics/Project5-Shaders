uniform sampler2D uSphereTexture;

varying vec2 vNormal;

void main() {
    
    vec3 textureColor = texture2D( uSphereTexture, vNormal ).rgb;
    gl_FragColor = vec4( textureColor, 1. );

}