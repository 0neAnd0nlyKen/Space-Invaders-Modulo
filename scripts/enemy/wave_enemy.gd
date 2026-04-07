extends Enemy
class_name WaveEnemy

# Moves in a sine wave pattern side to side

@export var wave_amplitude: float = 100
@export var wave_frequency: float = 2.0
var start_x: float = 0.0

func _ready() -> void:
	super()
	start_x = position.x

func move_enemy(delta: float) -> void:
	velocity.y = base_speed
	# Calculate horizontal wave movement
	var wave_offset = sin(time_alive * wave_frequency * PI) * wave_amplitude
	position.x = start_x + wave_offset
