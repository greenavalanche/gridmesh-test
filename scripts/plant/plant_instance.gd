extends Node3D
class_name PlantInstance

@export var plant: Plant
var current_stage := -1
var stage_instance: Node3D
var game: Game


func spawn(_game: Game, x: int, y: int):
	game = _game
	global_position = Vector3(x, 0, y)
	process_growth()

func set_stage(stage_idx: int) -> bool:
	if stage_idx >= plant.stages.size():
		return false
	var new_stage = plant.stages[stage_idx].scene.instantiate()
	if stage_instance:
		stage_instance.queue_free()
	add_child(new_stage)
	stage_instance = new_stage
	current_stage = stage_idx
	return true

func process_growth():
	while set_stage(current_stage + 1):
		var delay = game.manager.get_delay(plant.stages[current_stage].duration_days, 0, 0)
		await get_tree().create_timer(delay).timeout
