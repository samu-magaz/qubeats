class_name QubitTrigger
extends Node3D

var state: int = 0
@export var mat: Material
var originalPosition
var trigger_op
var master: mastermind

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_node("MeshInstance3D").material_override = mat
	originalPosition = global_position.y
	#esto tiene que ser mejorable, basicamente accede a la scena padre
	master = get_tree().current_scene.get_node("Mastermind")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _Selected()-> void:
	global_position.y = originalPosition - 0.25
	state = 1
	pass

func _Deselected()-> void:
	if state == 1:
		global_position.y = originalPosition
	state = 0
	pass
	
func _Trigger(operator: String)-> void:
	trigger_op = operator
	global_position.y = originalPosition + 0.25
	if $Area3D.has_overlapping_bodies():
		print("ParchePirata")
	pass
	
func _Recover()-> void: #esta funcion es mejorable
	global_position.y = originalPosition - 0.25
	trigger_op = ""
	#if global_position.y != originalPosition:
		#global_position.y = originalPosition
	pass
	
func _on_body_entered(body: Node3D) -> void:
	print("Entró:", body.name)
		

func _on_area_3d_body_entered(body: Node3D) -> void: #este código hay que limpiarlo
	var collision = body.get_parent()
	print("Collision")
	if collision is Qubit:
		if trigger_op == "X":
			collision.apply_operator(Qubit.OPERATOR.X)
		elif trigger_op == "C":
			collision.apply_operator(Qubit.OPERATOR.H)
		if collision.state == Qubit.QUBIT_STATE.ZERO:
			lerp(collision.scale, collision.scale * 1.2, 1)
			master.start_scoring_loop()
			body.get_parent().queue_free()
		else:
			lerp(collision.scale, collision.scale * 0.8, 1)
			#body.get_parent().queue_free()
			
