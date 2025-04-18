class_name Manager
extends Node

@export var START_MANA_TOTAL: float = 3.0
@export var START_MANA: float = 3.0
@export var START_WATER: float = 1.0
@export var MANA_PER_INFLUENCE_PER_DAY: float = 0.33
var time: GameTime
var time_speeds = [0.0, 1.0, 16.0]
var time_speed_idx: int = 1

var mana: FloatResource = FloatResource.new(START_MANA, 0.0, START_MANA_TOTAL)
var water: FloatResource = FloatResource.new(START_WATER)
var influence: FloatResource = FloatResource.new(START_MANA_TOTAL)
var num_plants: int = 0

var plants: Array[Plant] = []

var prev_time: float

func _ready() -> void:
	time = GameTime.new(0.0)

func _process(delta: float) -> void:
	process_time_speed_toggle()
	time.flow(delta)
	process_cheat_codes(delta)
	var time_delta = time.time - prev_time
	replenish_mana(time_delta)
	replenish_water(time_delta)
	prev_time = time.time

func process_time_speed_toggle():
	if Input.is_action_just_pressed("time_flow_toggle"):
		time_speed_idx = (time_speed_idx + 1) % time_speeds.size()
		time.speed = time_speeds[time_speed_idx]

func process_cheat_codes(delta):
	if Input.is_action_pressed("cheat_water"):
		water.add(delta)
	if Input.is_action_pressed("cheat_mana"):
		mana.add(delta)
	if Input.is_action_pressed("cheat_influence"):
		influence.add(delta)

func replenish_mana(delta: float):
	mana.add(delta / time.get_delay(1) * influence.value * MANA_PER_INFLUENCE_PER_DAY)

func replenish_water(delta: float):
	water.add(delta / time.get_delay(1) * num_plants)
