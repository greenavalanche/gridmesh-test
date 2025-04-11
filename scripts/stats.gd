extends CanvasLayer

@onready var game: Game = %Game

@onready var fps: Label = $VBoxContainer/FPS
@onready var day: Label = $VBoxContainer/Day
@onready var time: Label = $VBoxContainer/Time
@onready var cursor_pos: Label = $VBoxContainer/CursorPos
@onready var tile_name: Label = $VBoxContainer/TileName
@onready var terrain_name: Label = $VBoxContainer/TerrainName
@onready var tile_plant: Label = $VBoxContainer/TilePlant
@onready var tile_distance: Label = $VBoxContainer/TileDistance
@onready var tile_influence: Label = $VBoxContainer/TileInfluence


@onready var mana: Label = $HBoxContainer/Mana
@onready var water: Label = $HBoxContainer/Water
@onready var influence: Label = $HBoxContainer/Influence


func _process(_delta: float) -> void:
	fps.text = "FPS %0.2f" % (1.0/_delta)
	day.text = "Day " + str(game.manager.time.get_day())
	time.text = "Time: " + game.manager.time.time_string()
	cursor_pos.text = "Pos: " + str(game.selected_position)
	tile_name.text = "Tile name: " + game.selected_tile_name
	terrain_name.text = "Terrain: " + game.selected_tile_terrain
	var plant = game.selected_tile.plant
	if not plant:
		tile_plant.text = ""
	else:
		tile_plant.text =  "Plant: %s [%s / %s] %s%%" % [
			plant.to_string(),
			plant.get_stage() + 1,
			plant.num_stages(),
			floor(plant.get_stage_progress() * 100),
		]
	
	tile_distance.text = "Tile Distance: %0.2f" % game.get_selected_tile_distance()
	tile_influence.text = "Tile Influence: %0.2f" % game.get_selected_tile_influence()
	
	mana.text = "Mana: %0.2f" % game.manager.mana.value
	water.text = "Water: %0.2f" % game.manager.water.value
	influence.text = "Influence: %0.2f" % game.manager.influence.value
