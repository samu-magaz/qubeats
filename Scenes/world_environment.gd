extends WorldEnvironment

@export var speed = 0.125
var noise = self.environment.sky.sky_material.panorama.noise

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
var cum = 0
func _process(delta: float) -> void:
	cum += delta
	#noise.offset.x += cos(delta * speed) * speed
	#noise.offset.y += sin(delta * speed) * speed
	#noise.offset.z += sin(delta * speed) * speed
	self.environment.sky.sky_material.panorama.height = 256 * (sin(cum * speed) + 1)/2 + 1
	self.environment.sky.sky_material.panorama.width = 256 * (cos(cum * speed) + 1)/2 + 1
	self.environment.sky.sky_material.emit_changed()
	
