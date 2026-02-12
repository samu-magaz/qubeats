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

var wave_scene = load("res://Scenes/Wave.tscn")
var waves_left = []
var waves_right = []

var spectrum_instance
const NUM_WAVES = 8  # Number of frequency bands to display
const MAX_FREQ = 1000  # Frequency range to analyze

func _ready() -> void:
	if song_selection == SONG.SYNTHWAVE:
		song_name = "the_mountain-synthwave"
	elif song_selection == SONG.RETRO:
		song_name = "delosound-retro"
	
	load_chart("res://Assets/Beatmaps/" + song_name + ".json")
	audio_player.stream = load("res://Assets/Songs/" + song_name + ".wav")
	
	rng.seed = hash(song_name)
	
	for wave_list in [waves_left, waves_right]:
		for i in range(NUM_WAVES):
			var wave_instance: Node3D = wave_scene.instantiate()
			wave_instance.rotate_y(PI/2)
			wave_instance.rotate_x(PI/2)
			wave_instance.position.y += 3
			wave_instance.position.x += 15
			wave_instance.position.z += 20
			wave_instance.is_sin = (i % 2 == 0)
			wave_instance.is_neg = (i % 4 == 0 or i % 3 == 0)
			add_child(wave_instance)
			wave_list.append(wave_instance)
			
	for wave in waves_right:
		wave.position.x -= 17

	await get_tree().process_frame
	audio_player.play()

	spectrum_instance = AudioServer.get_bus_effect_instance(3, 0)  # Bus 1, Effect 0

#Ahora mismo crea un qubit random cada segundo. CAMBIAR
func _process(delta: float) -> void:
		
	var song_time = get_song_time()
	
	while next_note_index < notes.size():
		var note = notes[next_note_index]
		# TODO: fix note spawn time adjustment
		var spawn_time = note["time"] - 1.5
		
		if song_time >= spawn_time:
			_RandomQubitGenerator(qubit, rng.randi_range(0, 2) + 1)
			next_note_index += 1
		else:
			break
		
	if not spectrum_instance:
		return
	var max_freq_amp = MAX_FREQ
	
	for i in range(len(waves_left)):
		var freq_start = (i * MAX_FREQ) / NUM_WAVES
		var freq_end = ((i + 1) * MAX_FREQ) / NUM_WAVES
		var magnitude = spectrum_instance.get_magnitude_for_frequency_range(freq_start, freq_end).length()
		
		var intensity = (magnitude*1000) / (max_freq_amp * 1000.0) if max_freq_amp > 0 else 0.0
		intensity *= 1000
		intensity = clamp(intensity, 0.0, 1.0)  # Keep within valid range
		
		var wave = waves_left[i]
		wave.amplitude = lerp(float(wave.amplitude), intensity * 70 * (i % 5), intensity*25)
		wave.color = lerp(Vector4(0.50, 0.62, 1.00, 1.00), Vector4(0.37, 0.00, 1.00, 1.00), intensity*100)
		wave = waves_right[i]
		wave.amplitude = lerp(float(wave.amplitude), intensity * 70 * (i % 5), intensity*25)
		wave.color = lerp(Vector4(0.50, 0.62, 1.00, 1.00), Vector4(0.37, 0.00, 1.00, 1.00), intensity*100)
	
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
