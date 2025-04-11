extends Resource
class_name GameTime

@export var MINUTE_LENGTH: float = 0.1
var HOUR_LENGTH: float = 60.0 * MINUTE_LENGTH
var DAY_LENGTH: float = 24 * HOUR_LENGTH

var time: float
var hour: float
var minute: float
var day: int:
	get=get_day

func _init(_time: float):
	time = _time

func flow(delta: float):
	time += delta

func get_day():
	return __get_days() + 1

func __get_days() -> int:
	return int(time / DAY_LENGTH)

func time_string() -> String:
	var daytime: float = time - __get_days()
	var hour = int(daytime / HOUR_LENGTH)
	var minute = (daytime - hour * HOUR_LENGTH) / MINUTE_LENGTH
	return "%02d:%02d" % [hour, minute]

func get_delay(days: int = 0, hours: int = 0, minutes: int = 0):
	return float(days) * DAY_LENGTH + float(hours) * HOUR_LENGTH + float(minutes) * MINUTE_LENGTH
