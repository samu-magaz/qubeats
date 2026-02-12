extends Node

@export var amplitude = 1
@export var is_sin = true
@export var is_neg = true

@onready var mesh : MeshInstance3D = get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat = mesh.get_active_material(0)
	mesh.set_surface_override_material(0, mat.duplicate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	#var value = sin(Time.get_ticks_msec() * 0.001) * 1.5
	mesh.get_active_material(0).set_shader_parameter("amplitude", amplitude)
	mesh.get_active_material(0).set_shader_parameter("is_sin", is_sin)
	mesh.get_active_material(0).set_shader_parameter("is_neg", is_neg)
