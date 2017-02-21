
uniform sampler2D tDiffuse;
uniform float u_threshold;
uniform float u_kernel[9];
uniform vec2 u_scale;
varying vec2 f_uv;

#define MAX_LEVEL 16
/*
Fast arbitrary bayer matrix generation algorithm borrowed from:
https://www.shadertoy.com/view/XtV3RG
*/
float GetBayerFromCoordLevel(vec2 pixelpos)
{
	float finalBayer   = 0.0;
	float finalDivisor = 0.0;
  float layerMult	   = 1.0;

	for(float bayerLevel = float(MAX_LEVEL); bayerLevel >= 1.0; bayerLevel--) {
		vec2 bayercoord = mod(floor(pixelpos.xy / exp2(bayerLevel) * 2.0),2.0);
		layerMult *= 4.0;
		float line0202 = bayercoord.x * 2.0;
		finalBayer += mix(line0202,3.0 - line0202,bayercoord.y) / 3.0 * layerMult;
		finalDivisor += layerMult;
	}

	return finalBayer / finalDivisor;
}

vec4 closest(vec4 color) {
  float r, g, b;
  r = floor(color.r + u_threshold);
  g = floor(color.g + u_threshold);
  b = floor(color.b + u_threshold);
  vec4 rounded = vec4(r, g, b, 1.0);
  return rounded;
}

void main() {
  vec4 color = texture2D(tDiffuse, f_uv);
  vec2 xy = f_uv / u_scale;
  float bayer = GetBayerFromCoordLevel(xy) / 2.0;
  color += vec4(bayer, bayer, bayer, 1.0);
  gl_FragColor = closest(color);
}
