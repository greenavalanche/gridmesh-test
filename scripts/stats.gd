extends CanvasLayer

@onready var Manager: Node = %Manager
@onready var day: Label = $Day
@onready var time: Label = $Time

func _process(delta: float) -> void:
	day.text = "Day " + str(Manager.get_day())
	var t = Manager.get_time()
	time.text = "Time: " + t.string()
