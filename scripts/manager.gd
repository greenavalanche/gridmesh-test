class_name Manager
extends Node

@export var start_mana: float = 10.0
@export var start_water: float = 10.0
var time: GameTime

var mana: FloatResource
var water: FloatResource

func _ready() -> void:
	mana = FloatResource.new(start_mana)
	water = FloatResource.new(start_water)
	time = GameTime.new(0.0)

func _process(delta: float) -> void:
	time.flow(delta)
