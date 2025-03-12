extends SubViewport

@onready var main_camera: Camera3D = $"%Viewer/Camera3D"
var _camera: Camera3D

func _ready():
	get_tree().root.size_changed.connect(update_size)
	update_size()

	_camera = Camera3D.new()
	add_child(_camera)
	_camera.cull_mask = canvas_cull_mask
	#_camera.current = true

func _process(delta: float) -> void:
	update_camera()

func update_camera():
	_camera.global_transform = main_camera.global_transform

func update_size():
	size = get_tree().root.size
