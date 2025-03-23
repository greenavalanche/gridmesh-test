shader_type spatial;
render_mode unshaded, depth_test_disabled, depth_prepass_alpha;//, depth_prepass_alpha, depth_test_disabled, skip_vertex_transform;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;

uniform sampler2D effect_map;
uniform mat4 gridmap_transform;

uniform float FOG_DEPTH = 50.0;
uniform float MAX_FOG_AMOUNT = 0.95;
uniform vec3 FOG_COLOR: source_color = vec3(0.2);
const vec3 GRAYSCALE_WEIGHTS = vec3(0.299, 0.587, 0.114);

void vertex () {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float clip_depth = texture(depth_texture, SCREEN_UV).r;
	if (clip_depth < 0.0001) {
		ALBEDO = FOG_COLOR;
	} else {
		vec4 clip_pos = vec4(SCREEN_UV * 2.0 - 1.0, clip_depth, 1.0);

		vec4 view_pos = INV_PROJECTION_MATRIX * clip_pos;
		view_pos /= view_pos.w;

		float linear_depth = -view_pos.z;

		vec4 world_pos = INV_VIEW_MATRIX * view_pos;

		vec4 grid_pos = gridmap_transform * world_pos;
		vec2 texture_size = vec2(textureSize(effect_map, 0));

		//vec2 effect_uv = ((floor(grid_pos.xz) + vec2(0.5)) + texture_size / 2.0) / texture_size;
		vec2 effect_uv = (grid_pos.xz + texture_size / 2.0) / texture_size;

		float effect_intensity = texture(effect_map, effect_uv).r;
		//effect_intensity *= sin((clip_pos.x + clip_pos.y * TIME * 10.0);

		vec3 color = texture(screen_texture, SCREEN_UV).rgb;

		vec3 grayscale = vec3(dot(color, GRAYSCALE_WEIGHTS));

		float fog_extent = smoothstep(0.0, FOG_DEPTH, linear_depth);

		vec3 fog_color = mix(grayscale, FOG_COLOR, MAX_FOG_AMOUNT);
		grayscale = mix(grayscale, fog_color, fog_extent);

		vec3 desaturated_color = mix(color, grayscale, effect_intensity);

		ALBEDO = desaturated_color;

	}

}
