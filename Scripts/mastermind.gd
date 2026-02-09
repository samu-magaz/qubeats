class_name mastermind
extends Node

signal point_scored

# Called when the node enters the scene tree for the first time.
@export var triggerList: Array[QubitTrigger]
var qubit = load("res://Scenes/Qubit.tscn")
@export var mainScene: Node
var timer = 0.0
 
func _ready() -> void:
	pass

#Ahora mismo crea un qubit random cada segundo. CAMBIAR
func _process(delta: float) -> void:
	timer += delta
	if timer >= 1:
		timer = 0.0
		_RandomQubitGenerator(qubit, randi_range(0, 2) + 1)
		start_scoring_loop()
	
func _input(event):
	#Seleccionar y soltar los 3 trigger
	if event.is_action_pressed("Select_Left"):
		triggerList[0]._Selected()
	if event.is_action_released("Select_Left"):
		triggerList[0]._Deselected()
	if event.is_action_pressed("Select_Center"):
		triggerList[1]._Selected()
	if event.is_action_released("Select_Center"):
		triggerList[1]._Deselected()
	if event.is_action_pressed("Select_Right"):
		triggerList[2]._Selected()
	if event.is_action_released("Select_Right"):
		triggerList[2]._Deselected()
	#Disparar los triggers
	if event.is_action_pressed("Action"):#Asignado a tecla random en un futuro serán las operaciones
		for trigger in triggerList:
			if trigger.state == 1:
				trigger._Trigger()
	if event.is_action_released("Action"):#Asignado a tecla random en un futuro serán las operaciones
		for trigger in triggerList:
			if trigger.state == 0:
				trigger._Recover() #ESTO ES UN PUTO DRAMA

func _RandomQubitGenerator(qubit, channel):
	var newInstance = qubit.instantiate()
	mainScene.add_child(newInstance)
	newInstance.position = Vector3(channel * 3, 4.5, -1)

func start_scoring_loop() -> void:
		await get_tree().create_timer(2.0).timeout
		emit_signal("point_scored")
