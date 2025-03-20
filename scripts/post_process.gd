extends MeshInstance3D

@onready var grid_map: GridMap = %GridMap
@onready var game: Game = $"../../.."

var effect_texture: ImageTexture

func _ready():
	generate_effect_map()
	mesh.material.set_shader_parameter("effect_map", effect_texture)
	print("shader initialized")

func _process(_delta: float) -> void:
	mesh.material.set_shader_parameter("gridmap_transform", grid_map.global_transform.affine_inverse())

func generate_effect_map():
	var grid_extents = Rect2i(0, 0, 0, 0);
	for tile in grid_map.get_used_cells():
		grid_extents.position.x = min(grid_extents.position.x, tile.x)
		grid_extents.position.y = min(grid_extents.position.y, tile.z)
		grid_extents.end.x = max(grid_extents.end.x, tile.x + 1)
		grid_extents.end.y = max(grid_extents.end.y, tile.z + 1)
	
	var grid_size: int = (max(grid_extents.size.x, grid_extents.size.y) / 2 + 1) * 2
		
	var image = Image.create(grid_size, grid_size, false, Image.FORMAT_R8)
	image.fill(Color(0, 0, 0))  # Default: No grayscale effect
	
	for tile in grid_map.get_used_cells():
		var grayscale_intensity = get_grayscale_intensity_for_tile(tile)
		
		var x = tile.x + grid_size / 2
		var y = tile.z + grid_size / 2
		
		image.set_pixel(x, y, Color(grayscale_intensity, grayscale_intensity, grayscale_intensity))
	
	# Convert to a texture and update the material
	effect_texture = ImageTexture.create_from_image(image)
	game.maptexture = ImageTexture.create_from_image(image)
	
func get_grayscale_intensity_for_tile(tile_pos: Vector3i) -> float:
	return float(tile_pos.x*tile_pos.x + tile_pos.z*tile_pos.z) / 30.0;
	
	#var tile_id = grid_map.get_cell_item(tile_pos)
	#
	#match tile_id:
		#1: return 0.0  # No grayscale (Normal tile)
		#_: return 1.0
