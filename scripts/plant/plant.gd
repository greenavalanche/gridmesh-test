extends Node3D
class_name Plant

var game: Game
@export var plant: PlantResource
var x: int
var y: int
var current_stage_idx := -1
var current_stage: PlantStage
var progress_bar_scene: PackedScene
var progress_bar: XProgressBar
@export var progress_bar_height: float = 1.0

func _init(_game: Game, _plant: PlantResource, _x: int, _y: int):
	game = _game
	plant = _plant
	x = _x
	y = _y
	progress_bar_scene = preload("res://scenes/ui/progress_bar.tscn")

func _enter_tree() -> void:
	global_position = Vector3(x, 0, y)
	__process_growth()

func _exit_tree() -> void:
	if current_stage:
		current_stage.teardown()

func _process(delta: float) -> void:
	var progress: float = get_stage_progress()
	current_stage.node.scale = Vector3(progress, progress, progress)
	progress_bar.set_progress(progress)

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
	
	if progress_bar:
		progress_bar.queue_free()

	progress_bar = progress_bar_scene.instantiate()
	progress_bar.position = Vector3(0.5, 0.0, 0.5)
	progress_bar.init(game.world_camera, get_stage_progress(), progress_bar_height)
	add_child(progress_bar)
	
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
