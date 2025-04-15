extends MeshInstance3D

@onready var grid_map: GridMap = %GridMap
@onready var game: Game = $"../../.."

func _ready():
	generate_effect_map()
	mesh.material.set_shader_parameter("effect_map", game.maptexture)
	print("shader initialized")

func _process(_delta: float) -> void:
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
		
	var image = Image.create(grid_size, grid_size, false, Image.FORMAT_R8)
	image.fill(Color(1, 1, 1))
	
	for tile in grid_map.get_used_cells():
		var grayscale_intensity = get_grayscale_intensity_for_tile(tile)
		
		var x = tile.x + grid_size / 2
		var y = tile.z + grid_size / 2
		
		image.set_pixel(x, y, Color(grayscale_intensity, grayscale_intensity, grayscale_intensity))
	
	# Convert to a texture and update the material
	game.maptexture = ImageTexture.create_from_image(image)

func get_grayscale_intensity_for_tile(tile_pos: Vector3i) -> float:
	if not game.map:
		return 1.0
	var tile = game.map.tiles[tile_pos]
	return 1.0 - tile.color_amount()
