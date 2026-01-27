shader_type spatial;

varying vec3 world_position;

void vertex() {
	//world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_position = NODE_POSITION_WORLD;
}

float random(vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

vec3 get_building_color()
{
	vec2 sampled = vec2(ceil(world_position.x), ceil(world_position.z));
	float rand = random(sampled);
		if (rand > 0.7)
		{
			return vec3(0.3, 0.27, 0.21);
		}
		else if (rand > 0.5)
		{
			return vec3(0.45, 0.23, 0.18);
		}
		else if (rand > 0.4)
		{
			return vec3(0.4, 0.39, 0.2);
		}
	return vec3(0.3);
}

vec3 get_window(vec2 uv)
{
	if (uv.x < 0.1 || uv.x > 0.9 || uv.y < 0.1)
		return get_building_color();
	//return mix(vec3(1.0), vec3(0.0, 0.1, 0.4), uv.y + 0.3);
	return vec3(1.0 - uv.y - 0.3);
}

void fragment() {
	if (UV.y > 0.5 && UV.x > 0.33)
	{
		ALBEDO = get_building_color();
	}
	else
	{
		ALBEDO = get_window(vec2(mod(UV.x * 30.0, 1.0), mod(UV.y * 20.0, 1.0)));
	}
}

void light() {
    DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
