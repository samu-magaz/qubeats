class_name mastermind
extends Node


# Called when the node enters the scene tree for the first time.
@export var triggerList: Array[QubitTrigger]

 
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
