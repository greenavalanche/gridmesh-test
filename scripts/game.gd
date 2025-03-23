class_name Game
extends Node3D

signal selection_changed

@onready var cursor: Cursor = $SubViewportContainer/SubViewport/Cursor
@onready var grid_map: GridMap = %GridMap

var selected_tile: int
var selected_position: Vector3i
var selected_tile_name: String
var selected_tile_terrain: String

var map: Map

var maptexture: ImageTexture

func _ready() -> void:
	prepare_map()
	cursor.position_chagned.connect(cursor_position_changed)
	cursor_position_changed(cursor.grid_position)
	cursor.paint.connect(paint)

func paint(grid_position: Vector3i):
	set_color(grid_position, 1.0)

func cursor_position_changed(grid_position: Vector3i):
	selected_position = grid_position
	selected_tile = cursor.get_tile(grid_position)
	selected_tile_name = cursor.get_tile_name(selected_tile)

	selected_tile_terrain = map.tiles[selected_position].terrain_name()

	selection_changed.emit()

func prepare_map():
	map = Map.new()
	for cell in grid_map.get_used_cells():
		var item = grid_map.get_cell_item(cell)
		var tile = Tile.new()
		tile.terrain = MapEnums.MeshlibToTerrainMap[grid_map.mesh_library.get_item_name(item)]
		#tile.terrain = MapEnums.MeshlibToTerrainMap["House"]
		map.tiles[cell] = tile

func set_color(cell: Vector3i, amount: float):
	map.tiles[cell].color_amount = amount
