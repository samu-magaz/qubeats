extends Node3D

@export var amp = 2.0
@export var points = 1000
@export var shape_scale = 0.1

var shapes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in points:
		var new_shape = MeshInstance3D.new()
		new_shape.mesh = SphereMesh.new()
		new_shape.scale = Vector3(shape_scale, shape_scale, shape_scale)
		add_child(new_shape)
		new_shape.position += Vector3((i - points/2) * (shape_scale / 2),0,0)
		shapes.append(new_shape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var cum = 0
func _process(delta: float) -> void:
	cum += delta
	for shape: MeshInstance3D in shapes:
		shape.position.y = sin((shape.position.x + cum)) * amp
		
