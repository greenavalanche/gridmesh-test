shader_type spatial;
render_mode unshaded, depth_prepass_alpha;

uniform sampler2D scene_texture : source_color, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture;

void fragment() {
	ALBEDO = texture(scene_texture, SCREEN_UV).rgb;
}

