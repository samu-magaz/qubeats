class_name Scoreboard
extends Control
@onready var mastermind = $"../../Mastermind"
var score: int = 0
@onready var label: Label = $ScoreLabel

func _ready():
	mastermind.point_scored.connect(_on_point_scored)
	

func _on_point_scored() -> void:
	score += 100
	label.text = "Score: %d" % score
