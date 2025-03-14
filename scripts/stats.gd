extends CanvasLayer

@onready var manager: Manager = %Manager
@onready var game: Game = %Game

@onready var day: Label = $VBoxContainer/Day
@onready var time: Label = $VBoxContainer/Time
@onready var cursor_pos: Label = $VBoxContainer/CursorPos
@onready var tile: Label = $VBoxContainer/Tile
@onready var tile_name: Label = $VBoxContainer/TileName
@onready var terrain_name: Label = $VBoxContainer/TerrainName



func _process(_delta: float) -> void:
	day.text = "Day " + str(manager.get_day())
	var t = manager.get_time()
	time.text = "Time: " + t.string()
	cursor_pos.text = "Pos: " + str(game.selected_position)
	tile.text = "Tile: " + str(game.selected_tile)
	tile_name.text = "Tile name: " + game.selected_tile_name
	terrain_name.text = "Terrain: " + game.selected_tile_terrain
