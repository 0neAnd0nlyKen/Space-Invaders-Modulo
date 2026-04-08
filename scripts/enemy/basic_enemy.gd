extends Enemy
class_name BasicEnemy

# Straight down movement - your standard enemy

func move_enemy(_delta: float) -> void:
	velocity.y = base_speed
