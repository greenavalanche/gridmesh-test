class_name Cursor
extends MeshInstance3D

signal position_chagned(grid_position: Vector3i)

@onready var viewer: RemoteTransform3D = %Viewer
@onready var map: GridMap = %GridMap
var grid_position: Vector3i
var previous_grid_position: Vector3i

func _ready() -> void:
	update_position(true)

func _process(_delta: float) -> void:
	update_position()

func update_position(force_emit: bool = false):
	grid_position = map.local_to_map(viewer.global_position)
	global_transform.origin = map.map_to_local(grid_position)
	if previous_grid_position != grid_position or force_emit:
		previous_grid_position = grid_position
		position_chagned.emit(grid_position)

func get_tile(_grid_position: Vector3i):
	return map.get_cell_item(_grid_position)
