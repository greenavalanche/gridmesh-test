extends MeshInstance3D

@onready var grid_map: GridMap = %GridMap
@onready var game: Game = $"../../.."

@export var MIN_UNFOG_INFLUENCE: float = 0.1
@export_range(0.0, 1.0) var MAX_FOG_AMOUNT: float = 1.0
@export_color_no_alpha var FOG_COLOR = Color(0, 0, 0)
@export_range(0.5, 10.0) var GRAYSCALE_DIMMING: float = 2.0;

func _ready():
	update_shader()

func _process(_delta: float) -> void:
	update_shader()

func update_shader():
	mesh.material.set_shader_parameter("MAX_FOG_AMOUNT", MAX_FOG_AMOUNT)
	mesh.material.set_shader_parameter("FOG_COLOR", FOG_COLOR)
	mesh.material.set_shader_parameter("GRAYSCALE_DIMMING", GRAYSCALE_DIMMING)
	mesh.material.set_shader_parameter("gridmap_transform", grid_map.global_transform.affine_inverse())
	generate_effect_map()
	mesh.material.set_shader_parameter("effect_map", game.maptexture)

func generate_effect_map():
	var grid_extents = Rect2i(0, 0, 0, 0);
	for tile in grid_map.get_used_cells():
		grid_extents.position.x = min(grid_extents.position.x, tile.x)
		grid_extents.position.y = min(grid_extents.position.y, tile.z)
		grid_extents.end.x = max(grid_extents.end.x, tile.x + 1)
		grid_extents.end.y = max(grid_extents.end.y, tile.z + 1)
	
	var grid_size: int = (max(grid_extents.size.x, grid_extents.size.y) / 2 + 1) * 2
		
	var image = Image.create(grid_size, grid_size, false, Image.FORMAT_RG8)
	image.fill(Color(1, 1, 0))
	
	for tile in grid_map.get_used_cells():
		var grayscale_intensity = get_grayscale_intensity_for_tile(tile)
		var fog_intensity = get_fog_instensity_for_tile(tile)
		
		var x = tile.x + grid_size / 2
		var y = tile.z + grid_size / 2
		
		image.set_pixel(x, y, Color(grayscale_intensity, fog_intensity, 0.0))
	
	# Convert to a texture and update the material
	game.maptexture = ImageTexture.create_from_image(image)

func get_fog_instensity_for_tile(tile_pos: Vector3i) -> float:
	if not game.map:
		return 1.0
	return clamp(1.0 - inverse_lerp(MIN_UNFOG_INFLUENCE, 1.0, game.get_tile_influence(tile_pos)), 0.0, 1.0)

func get_grayscale_intensity_for_tile(tile_pos: Vector3i) -> float:
	if not game.map:
		return 1.0
	var tile = game.map.tiles[tile_pos]
	return 1.0 - tile.color_amount()
