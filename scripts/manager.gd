class_name Manager
extends Node

@export var START_MANA_TOTAL: float = 3.0
@export var START_MANA: float = 3.0
@export var START_WATER: float = 1.0
@export var MANA_PER_INFLUENCE_PER_DAY: float = 0.33
var time: GameTime

var mana: FloatResource = FloatResource.new(START_MANA, 0.0, START_MANA_TOTAL)
var water: FloatResource = FloatResource.new(START_WATER)
var influence: FloatResource = FloatResource.new(START_MANA_TOTAL)
var num_plants: int = 0

var plants: Array[Plant] = []

func _ready() -> void:
	time = GameTime.new(0.0)

func _process(delta: float) -> void:
	time.flow(delta)
	replenish_mana(delta)
	replenish_water(delta)
	process_cheat_codes(delta)

func process_cheat_codes(delta):
	if Input.is_action_pressed("cheat_water"):
		water.add(delta)
	if Input.is_action_pressed("cheat_mana"):
		mana.add(delta)
	if Input.is_action_pressed("cheat_influence"):
		influence.add(delta)
	if Input.is_action_pressed("cheat_time"):
		time.flow(delta*7)

func replenish_mana(delta: float):
	mana.add(delta / time.get_delay(1) * influence.value * MANA_PER_INFLUENCE_PER_DAY)

func replenish_water(delta: float):
	water.add(delta / time.get_delay(1) * num_plants)
