extends Node3D

@export var num_qubits: int = 5

@export var left_path: Path3D
@export var center_path: Path3D
@export var right_path: Path3D


var qubits = []
var qubit_resource = preload("res://Scenes/Qubit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var paths = [left_path, center_path, right_path]
	for path in paths:
		add_qubit(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var paths = [left_path, center_path, right_path]
	for path in paths:
		for pathfollow in path.get_children():
			pathfollow.progress_ratio += delta * 0.5
	for qubit in qubits:
		qubit.rotate_y(delta * 0.5)
		
func add_qubit(path: Path3D) -> void:
	var qubit = qubit_resource.instantiate()
	qubits.append(qubit)
	qubit.auto_translate_mode = true
	
	var pathfollow = PathFollow3D.new()
	pathfollow.add_child(qubit)
	path.add_child(pathfollow)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("AddLeft"):
		add_qubit(left_path)
	if event.is_action_pressed("AddCenter"):
		add_qubit(center_path)
	if event.is_action_pressed("AddRight"):
		add_qubit(right_path)
		
