extends MeshInstance3D
class_name ProgressBarMesh

var mat: ShaderMaterial

func _ready():
	mat = preload("res://resources/ui/progress_bar.tres").duplicate(true)
	material_override = mat
	set_progress(0.0)

func set_progress(_progress: float):
	mat.set_shader_parameter("progress", _progress)
