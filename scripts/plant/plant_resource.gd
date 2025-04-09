extends Resource
class_name PlantResource

@export var name: String
@export var mana_to_plant: float
@export var stages: Array[PlantStageResource] = []
@export var plantable_on: Array[MapEnums.TerrainType] = []
