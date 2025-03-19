extends TextureRect

@onready var main_camera: Camera3D = $"%Viewer/Camera3D"
@onready var grid_map: GridMap = %GridMap

const EFFECT_TEXTURE_SIZE: int = 1024  # Set the resolution of the effect map
var effect_texture: ImageTexture

func _ready():
	generate_effect_map()
	material.set_shader_parameter("effect_map", effect_texture)
	print("shader initialized")

func _process(_delta: float) -> void:
	material.set_shader_parameter("gridmap_transform", grid_map.global_transform.affine_inverse())
	material.set_shader_parameter("inv_camera_projection", main_camera.get_camera_projection().inverse())
	material.set_shader_parameter("camera_transform", main_camera.global_transform)

func generate_effect_map():
	var image = Image.create(EFFECT_TEXTURE_SIZE, EFFECT_TEXTURE_SIZE, false, Image.FORMAT_R8)
	image.fill(Color(0, 0, 0))  # Default: No grayscale effect
	
	for tile in grid_map.get_used_cells():
		var grayscale_intensity = get_grayscale_intensity_for_tile(tile)
		
		var uv_x = tile.x % EFFECT_TEXTURE_SIZE + EFFECT_TEXTURE_SIZE / 2
		var uv_y = tile.z % EFFECT_TEXTURE_SIZE + EFFECT_TEXTURE_SIZE / 2
		
		image.set_pixel(uv_x, uv_y, Color(grayscale_intensity, grayscale_intensity, grayscale_intensity))
	
	# Convert to a texture and update the material
	effect_texture = ImageTexture.create_from_image(image)
	
func get_grayscale_intensity_for_tile(tile_pos: Vector3i) -> float:
	var tile_id = grid_map.get_cell_item(tile_pos)
	
	match tile_id:
		0: return 0.0  # No grayscale (Normal tile)
		_: return 1.0
