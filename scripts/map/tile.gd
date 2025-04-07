extends Node
class_name MapTile

@export var terrain: MapEnums.TerrainType
var plant: Plant = null

func terrain_name() -> String:
	return MapEnums.TerrainType.find_key(terrain)

func color_amount() -> float:
	if not plant:
		return 0.0
	else:
		return plant.get_influence()
