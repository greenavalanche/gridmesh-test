extends TextureRect
@onready var game: Game = %Game

func _ready() -> void:
	texture = game.maptexture

func _process(_delta) -> void:
	texture = game.maptexture
