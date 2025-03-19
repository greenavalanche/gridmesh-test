extends Camera3D

@onready var world_camera: Camera3D = $"../WorldViewport/Viewer/WorldCamera"
@onready var post_process_display: MeshInstance3D = $PostProcessDisplay


func _ready() -> void:
	#make_current()
	sync_camera()

func _process(_delta: float) -> void:
	sync_camera()

func sync_camera():
	fov = world_camera.fov
	near = world_camera.near
	far = world_camera.far
	global_transform = world_camera.global_transform
