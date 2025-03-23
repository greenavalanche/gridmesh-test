extends Node
class_name Tile

@export var terrain: MapEnums.TerrainType
var color_amount: float = 1.0

func terrain_name() -> String:
	return MapEnums.TerrainType.find_key(terrain)
