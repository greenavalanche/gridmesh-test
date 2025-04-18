class_name Cursor
extends MeshInstance3D

signal position_chagned(grid_position: Vector3i)
signal tile_action(grid_position: Vector3i)

const TEST_PIXEL_SCENE = preload("res://scenes/test_pixel.tscn")

@onready var game: Game = $".."
@onready var viewer: RemoteTransform3D = %Viewer
@onready var map: GridMap = %GridMap
var grid_position: Vector3i
var control_position: Vector3

var pixel_nodes: Array[Node3D] = []


func _ready() -> void:
	update_position(viewer.global_position, true)
	control_position = map.map_to_local(grid_position)

func _process(delta: float) -> void:
	#update_position(viewer.global_position)
	process_move(delta)
	update_position(control_position)
	if Input.is_action_just_pressed("cursor_reset"):
		cursor_reset()
	if Input.is_action_just_pressed("tile_action"):
		tile_action.emit(grid_position)

func process_move(delta: float):
	if (control_position - map.map_to_local(grid_position)).length_squared() > 1.0:
		control_position = map.map_to_local(grid_position)

	var move_input = Vector2(Input.get_axis("cursor_left", "cursor_right"), Input.get_axis("cursor_up", "cursor_down"))
	if move_input.length_squared() > viewer.INPUT_DEADZONE:
		var position_delta = Vector3(move_input.x, 0, move_input.y) * delta * viewer.MOVE_FACTOR
		position_delta = position_delta.rotated(Vector3.UP, viewer.rotation.y)
		control_position += position_delta

func cursor_reset():
	control_position = map.map_to_local(game.player.grid_position)

func draw_test_line(pixels: Array[Vector3i]):
	for p in pixel_nodes:
		p.queue_free()
	
	pixel_nodes = []
	
	for pixel in pixels:
		var pixel_node = TEST_PIXEL_SCENE.instantiate()
		pixel_node.position = pixel
		pixel_nodes.append(pixel_node)
		map.add_child(pixel_node)


func update_position(input_position: Vector3, force_emit: bool = false):
	if not game.is_node_ready():
		grid_position = map.local_to_map(input_position)
		position = map.map_to_local(grid_position)
		return

	var projected_position: Vector3i = map.local_to_map(input_position)
	var pixels = Utils.grid_interpolate(projected_position, game.player.grid_position)
	
	#draw_test_line(pixels)
	
	var new_position = null
	
	for p in pixels:
		if game.get_tile_influence(p) > 1.0:
			new_position = p
			break

	position = map.map_to_local(grid_position)
	if new_position != grid_position or force_emit:
		var old_pos_distance = projected_position.distance_squared_to(grid_position)
		var new_pos_distance = projected_position.distance_squared_to(new_position)

		if not force_emit and new_pos_distance > old_pos_distance:
			return

		grid_position = new_position
		position_chagned.emit(grid_position)

func get_tile(_grid_position: Vector3i):
	return map.get_cell_item(_grid_position)

func get_tile_name(tile_index: int):
	return map.mesh_library.get_item_name(tile_index)
