shader_type canvas_item;

uniform sampler2D effect_map;
uniform mat4 gridmap_transform;
uniform mat4 inv_camera_projection;
uniform mat4 camera_transform;
uniform float GROUND_HEIGHT;
uniform float OPACITY;

uniform float effect_radius = 5.0;
const vec3 GRAYSCALE_WEIGHTS = vec3(0.299, 0.587, 0.114);

void fragment() {
	vec4 clip_pos = vec4(UV * 2.0 - 1.0, 0.0, 1.0);
	clip_pos.y *= -1.0; // !!! Y-up/Y-down conversion

	vec4 view_pos = inv_camera_projection * clip_pos;
	view_pos /= view_pos.w;

	vec4 world_pos = camera_transform * view_pos;

    vec3 ray_origin = camera_transform[3].xyz;

    vec3 ray_dir = normalize(world_pos.xyz - ray_origin);

	if (ray_dir.y < 0.0) {
    	float t = (GROUND_HEIGHT - ray_origin.y) / ray_dir.y;
    	vec3 intersection = ray_origin + t * ray_dir;
		vec3 grid_pos = (gridmap_transform * vec4(intersection, 1.0)).xyz;

		vec2 tex_size = vec2(textureSize(effect_map, 0));
		vec2 effect_uv = (grid_pos.xz + tex_size / 2.0) / tex_size;

		vec2 effect_radius_uv = effect_radius / tex_size;

		//float min_grayscale = 0.0;
		//
		//for (float x = -effect_radius_uv; x < effect_radius_uv; x += 1.0 / tex_size.x) {
			//
		//}


		float effect_intensity = texture(effect_map, effect_uv).r;

		vec3 original_color = texture(TEXTURE, UV).rgb;
		vec3 grayscale = vec3(dot(original_color, GRAYSCALE_WEIGHTS));
		vec3 final_color = mix(original_color, grayscale, effect_intensity);


		//vec3 color = fract(grid_pos);
		COLOR = vec4(final_color, 1.0);
	}
}
