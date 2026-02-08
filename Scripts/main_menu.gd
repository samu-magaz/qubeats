class_name MainMenu
extends Control

@onready var start_button = $VBoxContainer/Start as Button
@onready var settings_button =  $VBoxContainer/Settings as Button
@onready var exit_button =  $VBoxContainer/Exit as Button
@onready var settings_menu = $Settings_Menu as SettingsMenu
@onready var vbox_container = $VBoxContainer as VBoxContainer
@onready var start_level = preload("res://Scenes/Fase1.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)


func _on_settings_pressed() -> void:
	vbox_container.visible = false
	settings_menu.visible = true
 # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
 # Replace with function body.

func on_exit_settings_menu() -> void:
	vbox_container.visible = true
	settings_menu.visible = false



func handle_connecting_signals() -> void:
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)
	
