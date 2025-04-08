extends Resource
class_name PlantStage

var resource: PlantStageResource

var node: Node3D

var game: Game
var start_time: float
var duration: float


func _init(_game: Game, _resource: PlantStageResource):
	game = _game
	resource = _resource
	start_time = game.manager.time
	duration = game.manager.get_delay(resource.duration_days, resource.duration_hours, resource.duration_minutes)
	node = resource.scene.instantiate()

func teardown() -> void:
	node.queue_free()

func get_progress() -> float:
	return clamp((game.manager.time - start_time) / duration, 0.0, 1.0)

func get_influence() -> float:
	return self.resource.influence * self.get_progress()
