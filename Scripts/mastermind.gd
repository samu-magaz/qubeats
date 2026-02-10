class_name mastermind
extends Node

signal point_scored

# Called when the node enters the scene tree for the first time.
@export var triggerList: Array[QubitTrigger]
var qubit = load("res://Scenes/Qubit.tscn")
@export var mainScene: Node
var timer = 0.0

@export var audio_player: AudioStreamPlayer3D
 
enum SONG { SYNTHWAVE = 0, RETRO = 1 }
@export var song_selection: SONG
var song_name = ""

var total_length = 0
var speed = 1

var chart = {}
var chart_offset = chart.get("offset", 0.0)
var notes = []
var next_note_index := 0

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	if song_selection == SONG.SYNTHWAVE:
		song_name = "the_mountain-synthwave"
	elif song_selection == SONG.RETRO:
		song_name = "delosound-retro"
	
	load_chart("res://Assets/Beatmaps/" + song_name + ".json")
	audio_player.stream = load("res://Assets/Songs/" + song_name + ".wav")
	
	rng.seed = hash(song_name)

	await get_tree().process_frame
	audio_player.play()

#Ahora mismo crea un qubit random cada segundo. CAMBIAR
func _process(delta: float) -> void:
		
	var song_time = get_song_time()
	
	while next_note_index < notes.size():
		var note = notes[next_note_index]
		# TODO: fix note spawn time adjustment
		var spawn_time = note["time"] - 1.5
		
		if song_time >= spawn_time:
			_RandomQubitGenerator(qubit, rng.randi_range(0, 2) + 1)
			#add_qubit(paths.get(rng.randi_range(0, 2)))
			#add_qubit(paths.get(int(note["lane"])))
			start_scoring_loop()
			next_note_index += 1
		else:
			break
			
	#timer += delta
	#if timer >= 1:
		#timer = 0.0
		#_RandomQubitGenerator(qubit, randi_range(0, 2) + 1)
	
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
	if event.is_action_pressed("OperadorX") or event.is_action_pressed("OperadorH"):#Asignado a tecla random en un futuro serán las operaciones
		for trigger in triggerList:
			if trigger.state == 1:
				trigger._Trigger(event.as_text())
	if event.is_action_released("OperadorX") or event.is_action_released("OperadorH"):#Asignado a tecla random en un futuro serán las operaciones
		for trigger in triggerList:
			if trigger.state == 1:
				trigger._Recover() #ESTO ES UN PUTO DRAMA


func load_chart(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	chart = JSON.parse_string(file.get_as_text())

	notes = chart["notes"]
	next_note_index = 0

func get_song_time() -> float:
	return (
		audio_player.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
		- chart_offset
	)
	
func _RandomQubitGenerator(qubit, channel):
	var newInstance = qubit.instantiate()
	newInstance.set_state(rng.randi() % 2 + 1)
	newInstance.rotate_y(PI)
	mainScene.add_child(newInstance)
	newInstance.position = Vector3(channel * 3, 4.5, -1)

func start_scoring_loop() -> void:
		emit_signal("point_scored")
