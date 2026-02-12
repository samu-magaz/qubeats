extends Control


@onready var audio_name_lbl = $HBoxContainer/Audio_Name_Lbl as Label
@onready var audio_num_lbl = $HBoxContainer/Audio_Num_Lbl as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider


@export_enum("Master","Music","Sfx") var bus_name : String
