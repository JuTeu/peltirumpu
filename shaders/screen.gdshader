shader_type spatial;

uniform float progress = 0.0;
uniform sampler2D tex : source_color, filter_linear_mipmap, repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 orb(vec2 uv, float prog) {
	if (prog < 0.5)
	{
		prog *= 2.0;
	}
	else
	{
		prog = 1.0 - (prog - 0.5) * 2.0;
	}
	uv.x -= 0.5;
	uv.x *= 4.0 / 3.0;
	uv.x += 0.5;
	float dist = 1.0 - distance(uv, vec2(0.5));
	dist *= dist * dist * dist * dist;
	float prog1 = 1.0 - prog;
	prog1 *= prog1;
	prog1 = 1.0 - prog1;
	return vec3(dist * prog1 * 1.5);
}

float uvYAdjust(float y, float prog) {
	prog = min(1.0, prog * 2.0);
	y = y * 2.0 - 1.0;
	y *= 1.0 + prog * prog * prog * prog * 200.0;
	y = (y + 1.0) / 2.0;
	return y;
}

float uvXAdjust(float x, float prog)
{
	prog = max(0.0, (prog - 0.3) * 2.0);
	x = x * 2.0 - 1.0;
	x *= 1.0 + prog * prog * prog * prog * 200.0;
	x = (x + 1.0) / 2.0;
	return x;
}

void fragment() {
	float prog = progress;//mod(TIME, 1.0);
	vec2 adjustedUV = vec2(uvXAdjust(UV.x, prog), uvYAdjust(UV.y, prog));
	if (adjustedUV.y < 0.0 || adjustedUV.y > 1.0 || adjustedUV.x > 1.0 || adjustedUV.x < 0.0)
		ALBEDO = vec3(0.0);
	else
		ALBEDO = texture(tex, adjustedUV).rgb;
	ALBEDO = clamp(ALBEDO + orb(UV, prog), vec3(0.0), vec3(1.0));
	if (progress > 0.999)
	{
		ALBEDO = vec3(0.0);
	}
}

void light() {
	DIFFUSE_LIGHT = vec3(0.25);
}
