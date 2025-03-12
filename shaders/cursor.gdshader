shader_type spatial;
//render_mode blend_mix, cull_disabled, depth_draw_always, unshaded;
//render_mode blend_mix, cull_disabled, unshaded, depth_draw_always;


uniform vec4 color : source_color;
uniform vec4 edge_color: source_color;
uniform float edge_width = 0.1;

void fragment() {
	vec2 uv = UV;

    float border = 1.0 - (smoothstep(0.0, edge_width, uv.x) * smoothstep(0.0, edge_width, uv.y) *
                   smoothstep(1.0, 1.0 - edge_width, uv.x) * smoothstep(1.0, 1.0 - edge_width, uv.y));


	ALBEDO = mix(color.rgb, edge_color.rgb, border);
	EMISSION = mix(color.rgb, edge_color.rgb, border);
	ALPHA = mix(color.a, edge_color.a, border);
}
