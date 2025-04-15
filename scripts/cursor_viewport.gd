extends SubViewport

@onready var world_camera: Camera3D = %WorldCamera
var _camera: Camera3D

func _ready():
	get_tree().root.size_changed.connect(update_size)
	update_size()

	_camera = world_camera.duplicate()
	for n in _camera.get_children():
		_camera.remove_child(n)
	add_child(_camera)
	_camera.cull_mask = canvas_cull_mask
	#_camera.current = true

func _process(_delta: float) -> void:
	update_camera()

func update_camera():
	_camera.global_transform = world_camera.global_transform

func update_size():
	size = get_tree().root.size
