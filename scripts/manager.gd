class_name Manager
extends Node

var time: GameTime

func _ready() -> void:
	time = GameTime.new(0.0)

func _process(delta: float) -> void:
	time.flow(delta)
