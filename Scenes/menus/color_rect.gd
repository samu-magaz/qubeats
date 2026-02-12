extends ColorRect

var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var cum = 0
func _process(delta: float) -> void:
	cum += delta
	#material.set_shader_parameter("gradient_text/noise/offset/y", cos(cum * speed) * 360)
	material.set_shader_parameter("noise_strength", (cos(cum * speed) + 1) * 0.1 + 0.5)
	material.set_shader_parameter("gradient_text/width", (sin(cum * speed * 2) + 1) * 128)
	material.set_shader_parameter("gradient_text/height", (cos(cum * speed * 2) + 1) * 128)
