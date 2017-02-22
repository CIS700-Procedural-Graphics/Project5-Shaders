// source - https://forum.unity3d.com/threads/ported-cross-hatching-shader-from-webgl.136100/

uniform vec3 u_albedo;
uniform vec3 u_ambient;
uniform vec3 u_lightPos; 
uniform vec3 u_lightCol;
uniform float u_lightIntensity;
uniform vec3 u_cameraPos;

varying vec3 f_position;
varying vec3 f_normal;
varying vec2 f_uv;


void main() {
    vec4 color = vec4(u_albedo, 1.0);
    gl_FragColor = color;

    vec3 light_direction = normalize(u_lightPos - f_position);
    float light_direction_weight = max(dot(normalize(f_normal), light_direction), 0.0);
    vec3 light_weight = u_ambient + u_lightCol * light_direction_weight;

    // check for outline
    vec3 camera_dir = normalize(u_cameraPos - f_position);
    if (dot(f_normal, camera_dir) < 0.2) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
        // originally i just have a simple sin function + noise, but it didn't look that great.
        // vary the mod values from 10 to 40 for different line distances, and use the sin method shown in class.
        if (length(light_weight) < 1.00) { 
            if (mod(gl_FragCoord.x + gl_FragCoord.y, 40.0) == 0.0) {
                gl_FragColor = color * (sin(gl_FragCoord.x + gl_FragCoord.y));
            }
        }

        if (length(light_weight) < 0.75) { 
            if (mod(gl_FragCoord.x - gl_FragCoord.y, 30.0) == 0.0) { 
                gl_FragColor = color * (sin(gl_FragCoord.x - gl_FragCoord.y));
            } 
        } 

        if (length(light_weight) < 0.50) {
            if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 16.0) == 0.0) { 
                gl_FragColor = color * (sin(gl_FragCoord.x + gl_FragCoord.y));
            }
        } 

        if (length(light_weight) < 0.3465) { 
            if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0) { 
                gl_FragColor = color * (sin(gl_FragCoord.x - gl_FragCoord.y));
            } 
        }
        gl_FragColor = gl_FragColor * u_lightIntensity;
    }
}
