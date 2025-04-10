class_name Manager
extends Node

@export var start_total_mana: float = 1.0
@export var start_mana: float = 1.0
@export var start_water: float = 1.0
var time: GameTime

var mana: FloatResource = FloatResource.new(start_mana, 0.0, start_total_mana)
var water: FloatResource = FloatResource.new(start_water)

func _ready() -> void:
	time = GameTime.new(0.0)

func _process(delta: float) -> void:
	time.flow(delta)
