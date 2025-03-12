extends CanvasLayer

@onready var manager: Manager = %Manager

@onready var day: Label = $VBoxContainer/Day
@onready var time: Label = $VBoxContainer/Time
@onready var cursor_pos: Label = $VBoxContainer/CursorPos
@onready var tile: Label = $VBoxContainer/Tile



func _process(delta: float) -> void:
	day.text = "Day " + str(manager.get_day())
	var t = manager.get_time()
	time.text = "Time: " + t.string()
	cursor_pos.text = "Pos: " + str(manager.get_position())
	tile.text = "Tile: " + str(manager.get_tile())
