shader_type spatial;

uniform vec4 INSIDE_COLOR : source_color = vec4(0.5, 1.0, 0.7, 0.7);
uniform vec4 EDGE_COLOR: source_color = vec4(0.0, 1.0, 0.0, 0.0);
uniform float FALLOFF = 0.3;
uniform float power : hint_range(0.0, 1.0, 0.1) = 1.0;

void fragment() {
	float fresnel = 1.0 - dot(NORMAL, VIEW);
    fresnel = pow(fresnel, FALLOFF);
	vec4 color = mix(INSIDE_COLOR, EDGE_COLOR, fresnel);

    EMISSION = color.rgb * power;
	ALBEDO = vec3(0.0);
	ALPHA = color.a;
}
