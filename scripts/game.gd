class_name Game
extends Node3D

signal selection_changed

@onready var cursor: Cursor = $SubViewportContainer/SubViewport/Cursor
var selected_tile: int
var selected_position: Vector3i
var selected_tile_name: String

func _ready() -> void:
	cursor.position_chagned.connect(cursor_position_changed)
	cursor_position_changed(cursor.grid_position)

func cursor_position_changed(grid_position: Vector3i):
	selected_position = grid_position
	selected_tile = cursor.get_tile(grid_position)
	selected_tile_name = cursor.get_tile_name(selected_tile)
	selection_changed.emit()
