extends Node
class_name Tile

@export var terrain: MapEnums.TerrainType

func terrain_name() -> String:
	return MapEnums.TerrainType.find_key(terrain)
