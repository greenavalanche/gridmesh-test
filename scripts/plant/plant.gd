extends Node3D
class_name Plant

const PROGRESS_BAR_SCENE: PackedScene = preload("res://scenes/ui/progress_bar.tscn")
const INPUT_INDICATOR_SCENE: PackedScene = preload("res://scenes/ui/input_indicator.tscn")
const COLLECT_INDICATOR_SCENE: PackedScene = preload("res://scenes/ui/collect_indicator.tscn")

var game: Game
var plant: PlantResource
var x: int
var y: int
var current_stage_idx := -1
var current_stage: PlantStage
var progress_bar: XProgressBar
var water_indicator: Node3D

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

func _process(_delta: float) -> void:
	var progress: float = current_stage.get_progress()
	current_stage.node.scale = Vector3(progress, progress, progress)
	if 0.0 < progress and progress < 1.0 and not progress_bar:
		create_progress_bar()
	elif progress == 1.0 and progress_bar:
		progress_bar.queue_free()
		progress_bar = null
	elif progress_bar:
		progress_bar.set_progress(progress)
	elif needs_water() and not water_indicator:
		create_water_indicator()
	elif water_indicator and not needs_water():
		water_indicator.queue_free()
		water_indicator = null
	if progress == 1.0:
		__process_growth()

func _to_string() -> String:
	return plant.name

func __center_node(_node: Node3D):
	_node.position = Vector3(0.5, 0, 0.5)

func set_stage(stage_idx: int) -> bool:
	if stage_idx >= plant.stages.size():
		return false
	var new_stage = PlantStage.new(game, plant.stages[stage_idx])
	__center_node(new_stage.node)
	new_stage.node.scale = Vector3(0.0, 0.0, 0.0)
	if current_stage:
		current_stage.teardown()
	add_child(new_stage.node)
	current_stage = new_stage
	current_stage_idx = stage_idx
	
	if progress_bar:
		progress_bar.queue_free()
	
	return true

func create_progress_bar():
	progress_bar = PROGRESS_BAR_SCENE.instantiate()
	__center_node(progress_bar)
	progress_bar.init(game.world_camera, get_stage_progress(), plant.progress_bar_height)
	add_child(progress_bar)

func create_water_indicator():
	water_indicator = INPUT_INDICATOR_SCENE.instantiate()
	__center_node(water_indicator)
	add_child(water_indicator)

func water():
	current_stage.watered = true
	current_stage.start_growth()

func needs_water() -> bool:
	return current_stage and not current_stage.watered

func get_stage() -> int:
	return current_stage_idx

func num_stages() -> int:
	return plant.stages.size()

func get_stage_progress():
	return current_stage.get_progress()

func get_influence():
	return current_stage.get_influence()

func __process_growth():
	set_stage(current_stage_idx + 1)
