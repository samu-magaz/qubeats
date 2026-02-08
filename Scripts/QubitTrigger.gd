class_name QubitTrigger
extends Node3D

var state: int = 0
@export var mat: Material
var originalPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MeshInstance3D").material_override = mat
	originalPosition = global_position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _Selected()-> void:
	global_position.y = global_position.y -1
	state = 1
	pass
func _Deselected()-> void:
	if state == 1:
		global_position.y = global_position.y +1
	state = 0
	pass
	
func _Trigger()-> void:
	if state == 1:
		global_position.y = global_position.y + 2
		if get_node("Area3D").has_overlapping_bodies():
			print("ParchePirata")		
	state = 0
	pass
func _Recover()-> void: #esta funcion es mejorable
	if global_position.y != originalPosition:
		global_position.y = originalPosition
	pass
	
func _on_body_entered(body: Node3D) -> void:
	print("Entró:", body.name)
		

func _on_area_3d_body_entered(body: Node3D) -> void: #este código hay que limpiarlo
	var collision = body.get_parent()
	if collision is Qubit:
		if collision.state == Qubit.QUBIT_STATE.ZERO:
			body.get_parent().queue_free()
