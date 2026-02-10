extends Node3D

enum SONG { SYNTHWAVE = 0, RETRO = 1 }

@export var audio_player: AudioStreamPlayer3D
@export var num_qubits: int = 5

@export var left_path: Path3D
@export var center_path: Path3D
@export var right_path: Path3D

@export var song: SONG

var total_length = 0
var speed = 1

var qubits = []
var qubit_resource = preload("res://Scenes/Qubit.tscn")
var paths = {}

var chart = {}
var chart_offset = chart.get("offset", 0.0)
var notes = []
var next_note_index := 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_length = center_path.curve.get_baked_length()
	
	paths = {
		0: left_path, 
		1: center_path, 
		2: right_path
	}
	
	load_chart("res://Assets/Beatmaps/the_mountain-synthwave.json")
	audio_player.stream = load("res://Assets/Songs/the_mountain-synthwave.wav")
	
	rng.seed = hash("the_mountain-synthwave")

	await get_tree().process_frame
	audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	var song_time = get_song_time()
	
	while next_note_index < notes.size():
		var note = notes[next_note_index]
		# TODO: fix note spawn time adjustment
		var spawn_time = note["time"] - 1.2
		
		if song_time >= spawn_time:
			add_qubit(paths.get(rng.randi_range(0, 2)))
			#add_qubit(paths.get(int(note["lane"])))
			next_note_index += 1
		else:
			break
	for path in paths.values():
		for pathfollow in path.get_children():
			pathfollow.progress_ratio += delta * speed

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
		
func add_qubit(path: Path3D) -> void:
	var qubit = qubit_resource.instantiate()
	qubits.append(qubit)
	qubit.auto_translate_mode = true
	
	var pathfollow = PathFollow3D.new()
	pathfollow.loop = false
	pathfollow.add_child(qubit)
	path.add_child(pathfollow)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("AddLeft"):
		add_qubit(left_path)
	if event.is_action_pressed("AddCenter"):
		add_qubit(center_path)
	if event.is_action_pressed("AddRight"):
		add_qubit(right_path)
		
