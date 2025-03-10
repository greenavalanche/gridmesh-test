extends RemoteTransform3D

@export var INPUT_DEADZONE: float = 0.1
@export var MOVE_FACTOR: float = -10.0
@export var ROTATION_FACTOR: float = 10.0
@export_group("Zoom")
@export var ZOOM_FACTOR: float = 10.0
@export var ZOOM_MIN: float = 0.5
@export var ZOOM_MAX: float = 5.0

func _process(delta: float) -> void:
	var move_input = Vector2(Input.get_axis("camera_left", "camera_right"), Input.get_axis("camera_up", "camera_down"))
	var toggle_input = Input.is_action_pressed("camera_toggle")

	var camera_reset = Input.is_action_just_pressed("camera_reset")
	if camera_reset:
		position = Vector3.ZERO
		rotation = Vector3.ZERO
		scale = Vector3.ONE

	if move_input.length_squared() > INPUT_DEADZONE:
		if not toggle_input:
			# lateral camera movement
			var position_delta = Vector3(move_input.x, 0, move_input.y) * delta * MOVE_FACTOR
			position_delta = position_delta.rotated(Vector3.UP, rotation.y)
			position += position_delta
		else:
			# rotation + zoom
			var rotation_delta = Vector3(0, move_input.x, 0) * delta * ROTATION_FACTOR
			rotation += rotation_delta
			var scale_delta = Vector3.ONE * move_input.y * delta * ZOOM_FACTOR
			var new_scale = scale + scale_delta
			if new_scale.x < ZOOM_MIN:
				new_scale = Vector3.ONE * ZOOM_MIN
			if new_scale.x > ZOOM_MAX:
				new_scale = Vector3.ONE * ZOOM_MAX
			
			scale = new_scale
