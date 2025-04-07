extends Node3D
class_name Plant

@export var plant: PlantResource
var x: int
var y: int
var current_stage_idx := -1
var current_stage: PlantStage
var game: Game

func _init(_game: Game, _plant: PlantResource, _x: int, _y: int):
	game = _game
	plant = _plant
	x = _x
	y = _y

func _enter_tree() -> void:
	global_position = Vector3(x, 0, y)
	__process_growth()

func _exit_tree() -> void:
	if current_stage:
		current_stage.teardown()

func _process(delta: float) -> void:
	var progress: float = get_stage_progress()
	current_stage.node.scale = Vector3(progress, progress, progress)

func _to_string() -> String:
	return plant.name

func set_stage(stage_idx: int) -> bool:
	if stage_idx >= plant.stages.size():
		return false
	var new_stage = PlantStage.new(game, plant.stages[stage_idx])
	new_stage.node.position = Vector3(0.5, 0, 0.5)
	new_stage.node.scale = Vector3(0.0, 0.0, 0.0)
	if current_stage:
		current_stage.teardown()
	add_child(new_stage.node)
	current_stage = new_stage
	current_stage_idx = stage_idx
	return true

func get_stage() -> int:
	return current_stage_idx

func num_stages() -> int:
	return plant.stages.size()

func get_stage_progress():
	return current_stage.get_progress()

func get_influence():
	return current_stage.get_influence()

func __process_growth():
	while set_stage(current_stage_idx + 1):
		await get_tree().create_timer(current_stage.duration).timeout
