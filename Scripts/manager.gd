extends Node3D

@export var num_qubits: int = 5

var qubits = []
var qubit_resource = preload("res://Scenes/Qubit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var qubit_1 = qubit_resource.instantiate()
	add_child(qubit_1)
	qubits.append(qubit_1)
	qubit_1.translate(Vector3(-0.5, 0, 0))
	
	var qubit_2 = qubit_resource.instantiate()
	qubits.append(qubit_2)
	add_child(qubit_2)
	qubit_2.translate(Vector3(0.5, 0, 0))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for qubit in qubits:
		qubit.rotate_y(delta * 0.8)
