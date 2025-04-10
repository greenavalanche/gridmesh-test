shader_type spatial;
render_mode unshaded;

uniform float PULSING_AMPLITUDE = 0.05;
uniform float NOISE_AMOUNT = 0.01;
uniform vec4 INSIDE_COLOR : source_color = vec4(0.0, 1.0, 0.7, 0.0);
uniform vec4 EDGE_COLOR: source_color = vec4(0.0, 0.9, 0.3, 1.0);
uniform float pulsing_amount : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float power : hint_range(0.0, 1.0, 0.1) = 1.0;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
	vec3 normal = NORMAL;
	float noise = rand(abs(UV-vec2(0.5)));// + sin(TIME / 5000000.0));
	VERTEX = VERTEX + sin(TIME) * NORMAL * PULSING_AMPLITUDE * pulsing_amount + NORMAL * noise * NOISE_AMOUNT;
	NORMAL = normal;
}

void fragment() {
	float fresnel = 1.0 - dot(NORMAL, VIEW);
    fresnel = pow(fresnel, 3.0); // optional falloff
	vec4 color = mix(INSIDE_COLOR, EDGE_COLOR, fresnel);

	EMISSION = color.rgb * power;
    ALBEDO = color.rgb * power;
	ALPHA = color.a * pow(power, 0.1);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
