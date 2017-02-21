uniform sampler2D tDiffuse;
uniform float u_amount;
varying vec2 f_uv;

// tDiffuse is a special uniform sampler that THREE.js will bind the previously rendered frame to


//resources:
//https://en.wikipedia.org/wiki/Sobel_operator
//https://en.wikipedia.org/wiki/Kernel_(image_processing)#Convolution
//https://blog.saush.com/2011/04/20/edge-detection-with-the-sobel-operator-in-ruby/

uniform vec2 resolution;

//column based
mat3 sobel_x = mat3(vec3(-1.0, -2.0, -1.0), vec3(0.0), vec3(1.0, 2.0, 1.0));
mat3 sobel_y = mat3(vec3(-1.0, 0.0, 1.0), vec3(-2.0, 0.0, 2.0), vec3(-1.0, 0.0, 1.0));


void main() {
    vec4 col = texture2D(tDiffuse, f_uv);
    
    vec4 _result = vec4(0.0);
    float offset = 0.001;

    //neighbors
    vec2 _a = vec2(f_uv.x - offset, f_uv.y - offset);
    vec2 _b = vec2(f_uv.x, f_uv.y - offset);
    vec2 _c = vec2(f_uv.x + offset, f_uv.y - offset);

    vec2 _d = vec2(f_uv.x - offset, f_uv.y);
    vec2 _e = vec2(f_uv.x, f_uv.y);
    vec2 _f = vec2(f_uv.x + offset, f_uv.y);

    vec2 _g = vec2(f_uv.x - offset, f_uv.y + offset);
    vec2 _h = vec2(f_uv.x, f_uv.y + offset);
    vec2 _i = vec2(f_uv.x + offset, f_uv.y + offset);

    vec4 pixel_x = (sobel_x[0][0] * vec4(texture2D(tDiffuse, _a))) + (sobel_x[0][1] * vec4(texture2D(tDiffuse, _b))) + (sobel_x[0][2] * vec4(texture2D(tDiffuse, _c))) +
                    (sobel_x[1][0] * vec4(texture2D(tDiffuse, _d))) + (sobel_x[1][1] * vec4(texture2D(tDiffuse, _e)))   + (sobel_x[1][2] * vec4(texture2D(tDiffuse, _f))) +
                    (sobel_x[2][0] * vec4(texture2D(tDiffuse, _g))) + (sobel_x[2][1] * vec4(texture2D(tDiffuse, _h))) + (sobel_x[2][2] * vec4(texture2D(tDiffuse, _i)));


    vec4 pixel_y = (sobel_y[0][0] * vec4(texture2D(tDiffuse, _a))) + (sobel_y[0][1] * vec4(texture2D(tDiffuse, _b))) + (sobel_y[0][2] * vec4(texture2D(tDiffuse, _c))) +
                    (sobel_y[1][0] * vec4(texture2D(tDiffuse, _d))) + (sobel_y[1][1] * vec4(texture2D(tDiffuse, _e)))   + (sobel_y[1][2] * vec4(texture2D(tDiffuse, _f))) +
                    (sobel_y[2][0] * vec4(texture2D(tDiffuse, _g))) + (sobel_y[2][1] * vec4(texture2D(tDiffuse, _h))) + (sobel_y[2][2] * vec4(texture2D(tDiffuse, _i)));

    _result = sqrt((pixel_x * pixel_x) + (pixel_y * pixel_y));

    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    col.rgb = vec3(gray, gray, gray) * vec3(_result[0], _result[1], _result[2]);
    gl_FragColor = vec4(  col.rgb , 1.0  );
}
