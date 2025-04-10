extends Node3D
class_name Player

@onready var glow: MeshInstance3D = %Glow
@onready var dust: GPUParticles3D = %Dust
@onready var camera: Camera3D = %WorldCamera
@onready var game: Game = $".."

@export var MIN_SCALE: float = 0.3
@export var MAX_SCALE: float = 1.0


func _process(_delta: float) -> void:
	var power = game.manager.mana.get_usage()
	var _power = clamp(power, 0.01, 1.0)
	glow.look_at(camera.global_position, Vector3.MODEL_FRONT)
	var _scale = clamp(power, MIN_SCALE, MAX_SCALE)
	glow.scale = Vector3(_scale, _scale, _scale)
	dust.scale = Vector3(_scale, _scale, _scale)
	
	var glow_mat = glow.get_active_material(0) as ShaderMaterial
	glow_mat.set_shader_parameter("power", _power)
	glow_mat.set_shader_parameter("pulsing_amount", _power)
	var dust_mat = dust.draw_pass_1.surface_get_material(0) as ShaderMaterial
	dust_mat.set_shader_parameter("power", _power)
