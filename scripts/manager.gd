class_name Manager
extends Node

@onready var game: Game = %Game


@export var MINUTE_LENGTH: float = 0.1
var HOUR_LENGTH: float = 60.0 * MINUTE_LENGTH
var DAY_LENGTH: float = 24 * HOUR_LENGTH

var time = 0.0

class GameTime:
	var hour: int
	var minute: int
	
	func _init(h: int = 0, m: int = 0):
		hour = h
		minute = m
	
	func string() -> String:
		return "%02d:%02d" % [hour, minute]

func _ready() -> void:
	time = 0.0

func _process(delta: float) -> void:
	time += delta

func _get_days(_t=null) -> int:
	var t = _t if _t != null else time
	return int(t / DAY_LENGTH)

func get_day() -> int:
	return _get_days() + 1

func get_time() -> GameTime:
	var current_time: float = time
	var days = _get_days(current_time)
	var daytime = current_time - days * DAY_LENGTH
	var hour = int(daytime / HOUR_LENGTH)
	var minute = (daytime - hour * HOUR_LENGTH) / MINUTE_LENGTH
	return GameTime.new(hour, minute)

func get_tile():
	return game.selected_tile

func get_tile_name():
	return game.selected_tile_name

func get_position():
	return game.selected_position
