
uniform sampler2D tDiffuse;
uniform sampler2D pNoise;
uniform float u_amount;
varying vec2 f_uv;

uniform vec3 gradients3d[12];
uniform int time;
uniform int table[512];


float lerp(in float a, in float b, in float t)
{
	t = clamp(t, 0.0, 1.0);
	float val = t * b + (1.0 - t) * a;
	return val;
}

// the ease curve by Ken Perlin, which gives smoother results for LERP
float ecurve(in float t)
{
	return (t * t * t * (t * (t * 6.0 - 15.0) + 10.0));
}

// randomly select a 3d gradient given a corner's coordinates
vec3 pickGradient(in int x, in int y, in int z)
{
	int h1 = 0;
	// goddamn this frag shader error
	/*
	for (int i = 0; i < 512; i++) {
		if (i == x) {
			h1 = table[i];
			break;
		}
	}

	for (int i = 0; i < 512; i++) {
		if (i == y + h1) {
			h1 = table[i];
			break;
		}
	}

	for (int i = 0; i < 512; i++) {
		if (i == z + h1) {
			h1 = table[i];
			break;
		}
	}

	//int hash = table[z + table[y + table[x]]];
	float t = float(h1) / 256.0;
	*/
	vec3 g = vec3(0, 0, 0);

	for (int i = 0; i < 12; i++) {
		if (i == int(mod(float(x) + float(x)*float(y) + float(x)*float(y)*float(z), 12.0))) {
		//if (i == int(t * 12.0)) {
			g = gradients3d[i];
			break;
		}
	}
	return g; //gradients3d[int(t * 12.0)];
}

// uses time as z coordinate
float getnoise3d(in float x, in float y, in int numSamples)
{
	float tOffset = float(time) / 1000.0 / float(numSamples);
	//tOffset = 3.0;
	// position within gradient grid
	float xs = mod(x * float(numSamples), 255.0);
	float ys = mod(y * float(numSamples), 255.0);
	float zs = mod(tOffset * float(numSamples) , 255.0);
	// lower bound of grid cube
	int xlb = int(floor(xs));
	int ylb = int(floor(ys));
	int zlb = int(floor(zs));
	// 0 - 1 parameterization of grid cube
	float tx = ecurve(xs - float(xlb));
	float ty = ecurve(ys - float(ylb));
	float tz = ecurve(zs - float(zlb));

	// position in grid cube
	float px = xs - floor(xs);
	float py = ys - floor(ys);
	float pz = zs - floor(zs);

	// sample each corner

	// back left bottom
	float blb = dot(pickGradient(xlb, ylb, zlb), vec3(px, py, pz));
	// back right bottom
	float brb = dot(pickGradient(xlb + 1, ylb, zlb), vec3(px - 1.0, py, pz));
	// front left bottom
	float flb = dot(pickGradient(xlb, ylb, zlb + 1), vec3(px, py, pz - 1.0));
	float frb = dot(pickGradient(xlb + 1, ylb, zlb + 1), vec3(px - 1.0, py, pz - 1.0));
	// back left top
	float blt = dot(pickGradient(xlb, ylb + 1, zlb), vec3(px, py - 1.0, pz));
	float brt = dot(pickGradient(xlb + 1, ylb + 1, zlb), vec3(px - 1.0, py - 1.0, pz));
	float flt = dot(pickGradient(xlb, ylb + 1, zlb + 1), vec3(px, py - 1.0, pz - 1.0));
	float frt = dot(pickGradient(xlb + 1, ylb + 1, zlb + 1), vec3(px - 1.0, py - 1.0, pz - 1.0));


	// trilinear sample
	// back to front
	float l1 = lerp(brb, frb, tz);
	float l2 = lerp(blb, flb, tz);
	float l3 = lerp(brt, frt, tz);
	float l4 = lerp(blt, flt, tz);
	// bottom to top
	float l13 = lerp(l1, l3, ty);
	float l24 = lerp(l2, l4, ty);
	// left to right
	return lerp (l24, l13, tx);
}



void main() {

	float n = getnoise3d( f_uv.x, f_uv.y, 8);
	float c = cos(2.0 * n * 3.14159);
	float s = sin(2.0 * n * 3.14159);
	//vec4 noise = texture2D(pNoise, f_uv);
	//vec2 deformed = vec2(f_uv.x  + 2.0 * (u_amount - 0.5) * (f_uv.y - 0.5), f_uv.y);
	n = getnoise3d(f_uv.x, mod(f_uv.y + n * u_amount, 1.0), 16);
	vec2 deformed = vec2(f_uv.x, f_uv.y + n * u_amount);

    vec4 col = texture2D(tDiffuse, deformed);
    gl_FragColor = col;
}   