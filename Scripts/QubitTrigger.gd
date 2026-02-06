extends Node3D

var state: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _selected()-> void:
	global_position.y = global_position.y -1
	pass
func _deselected()-> void:
	global_position.y = global_position.y +1
	pass
	
func _input(event):
	if event.is_action_pressed("Select_Left"):
		_selected()
	if event.is_action_released("Select_Left"):
		_deselected()
