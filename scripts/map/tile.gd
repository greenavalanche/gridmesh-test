extends Node
class_name MapTile


@export var terrain: MapEnums.TerrainType
var plant: Plant = null
var game: Game
var grid_position: Vector2

func _init(_game: Game, _position: Vector2) -> void:
	game = _game
	grid_position = _position

func spawn_plant(plant_type: MapEnums.PlantType):
	if plant:
		return false
	print("spawn plant on %s at %s" % [terrain_name(), grid_position])
	var plant_resource = MapEnums.Plants[plant_type]
	plant = Plant.new(game, plant_resource, grid_position.x, grid_position.y)
	return plant

func terrain_name() -> String:
	return MapEnums.TerrainType.find_key(terrain)

func color_amount() -> float:
	if not plant:
		return 0.0
	else:
		return plant.get_influence()
