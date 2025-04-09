extends Resource
class_name PlantStage

var resource: PlantStageResource

var node: Node3D

var game: Game
var start_time = null
var duration: float
var watered: float = false


func _init(_game: Game, _resource: PlantStageResource):
	game = _game
	resource = _resource
	duration = game.manager.time.get_delay(resource.duration_days, resource.duration_hours, resource.duration_minutes)
	node = resource.scene.instantiate()

func teardown() -> void:
	node.queue_free()

func start_growth() -> void:
	start_time = game.manager.time.time

func water_needed() -> float:
	return resource.water_usage

func get_progress() -> float:
	if start_time:
		return clamp((game.manager.time.time - start_time) / duration, 0.0, 1.0)
	return 0.0

func get_influence() -> float:
	return self.resource.influence * self.get_progress()
