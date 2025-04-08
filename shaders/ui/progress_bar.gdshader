shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress: hint_range(0.0, 1.0);
uniform vec4 FILL_COLOR: source_color = vec4(0.5, 0.9, 0.0, 1.0);
uniform vec4 BG_COLOR: source_color = vec4(0.1, 0.1, 0.1, 0.5);

void fragment() {
	float filled = step(UV.y, progress);
	vec4 color = mix(BG_COLOR, FILL_COLOR, filled);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
