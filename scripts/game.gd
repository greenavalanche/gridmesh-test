extends Node3D
class_name Game

signal selection_changed

@onready var cursor: Cursor = %Cursor
@onready var grid_map: GridMap = %GridMap
@onready var manager: Manager = %Manager
@onready var world_camera: Camera3D = %WorldCamera
@onready var player: Player = %Player


var selected_tile: MapTile
var selected_position: Vector3i
var selected_tile_name: String
var selected_tile_terrain: String

var map: Map

var maptexture: ImageTexture

func _ready() -> void:
	prepare_map()
	cursor.position_chagned.connect(cursor_position_changed)
	cursor_position_changed(cursor.grid_position)
	cursor.tile_action.connect(tile_action)

func _process(delta: float) -> void:
	calculate_influence()

func calculate_influence():
	var influence: float = manager.mana.max_value
	var num_plants = 0
	for ti in map.tiles:
		var t: MapTile = map.tiles[ti]
		if t.plant:
			influence += t.plant.get_influence()
			num_plants += 1
	manager.influence.set_value(influence)
	manager.num_plants = num_plants

func cursor_position_changed(grid_position: Vector3i):
	selected_position = grid_position
	selected_tile = map.tiles[grid_position]
	selected_tile_name = cursor.get_tile_name(cursor.get_tile(grid_position))
	selected_tile_terrain = map.tiles[selected_position].terrain_name()
	selection_changed.emit()

func prepare_map():
	map = Map.new()
	for cell in grid_map.get_used_cells():
		var item = grid_map.get_cell_item(cell)
		var tile = MapTile.new(self, Vector2(cell.x, cell.z))
		tile.terrain = MapEnums.MeshlibToTerrainMap[grid_map.mesh_library.get_item_name(item)]
		#tile.terrain = MapEnums.MeshlibToTerrainMap["House"]
		map.tiles[cell] = tile


func tile_action(grid_position: Vector3i) -> void:
	var tile: MapTile = map.tiles[grid_position]
	if tile.plant:
		if tile.plant.needs_water():
			tile.water_plant()
	else:
		var plant = tile.spawn_plant(MapEnums.PlantType.FORGET_ME_NOT)
		if plant:
			add_child(plant)

func get_selected_tile_distance() -> float:
	return get_tile_distance(cursor.grid_position)

func get_selected_tile_influence() -> float:
	return get_tile_influence(cursor.grid_position)

func get_tile_distance(grid_position: Vector3i) -> float:
	var d: Vector3 = Vector3(abs(grid_position - player.grid_position))
	return sqrt(d.x*d.x + d.z * d.z)

func get_tile_influence(grid_position: Vector3i) -> float:
	var d = get_tile_distance(grid_position)
	return manager.influence.value / (1.0 + d*d)
