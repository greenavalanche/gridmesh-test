extends Node
class_name MapEnums

# to display the name:
# print(MapEnums.TerrainType.find_key(MapEnums.TerrainType.GROUND))

enum TerrainType { GROUND, ROAD, DWELLING }

const MeshlibToTerrainMap = {
	"House": TerrainType.DWELLING,
	"Intersection": TerrainType.ROAD,
	"Street": TerrainType.ROAD,
	"TJunction": TerrainType.ROAD,
	"Turn": TerrainType.ROAD,
	"Lawn": TerrainType.GROUND,
}
