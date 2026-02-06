extends Node3D

enum QUBIT_STATE { ZERO = 0, ONE = 1, PLUS = 2, MINUS = 3 }

enum OPERATOR { Z = 0, X = 1, H = 2 }

@export var state = QUBIT_STATE.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_color()

func _input(event):
	if event.is_action_pressed("OperadorZ"):
		apply_operator(OPERATOR.Z)
	if event.is_action_pressed("OperadorX"):
		apply_operator(OPERATOR.X)
	if event.is_action_pressed("OperadorH"):
		apply_operator(OPERATOR.H)

func set_color() -> void:
	if state == QUBIT_STATE.ZERO:
		$MeshInstance3D.material_override = preload("res://Material/Azul.tres")
	elif state == QUBIT_STATE.ONE:
		$MeshInstance3D.material_override = preload("res://Material/Rosa.tres")
	if state == QUBIT_STATE.PLUS:
		$MeshInstance3D.material_override = preload("res://Material/Naranja.tres")
	elif state == QUBIT_STATE.MINUS:
		$MeshInstance3D.material_override = preload("res://Material/Jungle.tres")

func apply_operator(operator: OPERATOR) -> void:
	if state == QUBIT_STATE.ZERO:
		if operator == OPERATOR.X:
			state = QUBIT_STATE.ONE
		elif operator == OPERATOR.H:
			state = QUBIT_STATE.PLUS
			
	elif state == QUBIT_STATE.ONE:
		if operator == OPERATOR.X:
			state = QUBIT_STATE.ZERO
		elif operator == OPERATOR.H:
			state = QUBIT_STATE.MINUS
			
	elif state == QUBIT_STATE.PLUS:
		if operator == OPERATOR.H:
			state = QUBIT_STATE.ZERO
		elif operator == OPERATOR.Z:
			state = QUBIT_STATE.MINUS
			
	elif state == QUBIT_STATE.MINUS:
		if operator == OPERATOR.H:
			state = QUBIT_STATE.ONE
		elif operator == OPERATOR.Z:
			state = QUBIT_STATE.PLUS
