shader_type canvas_item;

uniform mat4 camera_projection;
uniform mat4 camera_transform;
uniform float GROUND_HEIGHT;
uniform float OPACITY;

void fragment() {
	vec4 clip_pos = vec4(UV * 2.0 - 1.0, 0.0, 1.0);
	clip_pos.y *= -1.0; // !!! Y-up/Y-down conversion
	vec4 view_pos = inverse(camera_projection) * clip_pos;
	view_pos /= view_pos.w;

	vec4 world_pos = camera_transform * view_pos;

    vec3 ray_origin = camera_transform[3].xyz;

    vec3 ray_dir = normalize(world_pos.xyz - ray_origin);

	if (ray_dir.y < 0.0) {
    	float t = (GROUND_HEIGHT - ray_origin.y) / ray_dir.y;
    	vec3 intersection = ray_origin + t * ray_dir;

		vec3 color = fract(intersection);
		COLOR = vec4(color.r, 0.0, color.b, OPACITY);
	} else {
		COLOR = vec4(0.0);
	}
}
