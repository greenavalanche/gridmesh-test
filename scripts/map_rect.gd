extends TextureRect
@onready var game: Game = %Game

func _ready() -> void:
	texture = game.maptexture
	
