class_name SingleChannel
extends Node3D

@export var material_default : StandardMaterial3D
@export var material_selected : StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Road.set_surface_override_material(0, material_default)
	$Trigger/QubitTrigger.set_surface_override_material(0, material_default)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _Selected() -> void:
	$Road.set_surface_override_material(0, material_selected)
	$Trigger/QubitTrigger.set_surface_override_material(0, material_selected)
	$Trigger._Selected()
	
func _Deselected()-> void:
	$Road.set_surface_override_material(0, material_default)
	$Trigger/QubitTrigger.set_surface_override_material(0, material_default)
	$Trigger._Deselected()
	
func _Trigger(operator: String)-> void:
	$Trigger._Trigger(operator)
	
func _Recover()-> void: #esta funcion es mejorable
	$Trigger._Recover()
