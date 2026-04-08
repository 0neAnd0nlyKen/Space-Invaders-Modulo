extends Enemy
class_name HeavyEnemy

# Slower movement but more health and higher score

func _ready() -> void:
	# Override defaults for heavy enemy
	max_health = 40
	health = max_health
	enemy_score = 250
	base_speed = 15  # Slower
	super()

func move_enemy(_delta: float) -> void:
	# Heavy enemies move straight down but slower
	velocity.y = base_speed
