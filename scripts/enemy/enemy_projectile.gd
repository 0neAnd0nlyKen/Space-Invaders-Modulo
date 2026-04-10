extends Area2D
class_name EnemyProjectile

var speed: int = 750
var damage: float = 1

func _physics_process(delta):
	position += transform.y * speed * delta

func _on_Bullet_body_entered(body):
	if body is Player:
		queue_free()
