extends Node3D
class_name XProgressBar

@export var camera: Camera3D
@export var height: float
var original_height: float
@export var progress: float
@onready var mesh: ProgressBarMesh = %ProgressBarMesh


func init(_camera: Camera3D, _progress: float, _height: float) -> void:
	camera = _camera
	height = _height
	progress = _progress

func _ready() -> void:
	original_height = mesh.position.y
	mesh.position.y = original_height + height
	mesh.set_progress(progress)

func _process(_delta: float) -> void:
	rotation = camera.global_rotation

func set_progress(_progress: float):
	progress = _progress
	mesh.set_progress(progress)
